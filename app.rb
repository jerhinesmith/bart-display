require 'rubygems'
require 'sinatra'
require 'haml'
require 'yajl'
require 'sinatra/json'
require 'nokogiri'
require 'open-uri'

API_KEY = 'EXH4-PDS6-5Z49-YIYU'

get '/' do
  haml :index
end

get '/next/:station.json' do |station|
  doc = Nokogiri::HTML(open("http://api.bart.gov/api/etd.aspx?cmd=etd&orig=#{station}&key=#{API_KEY}"))

  departures = doc.xpath('//etd')

  results = []

  departures.each do |departure|
    destination = departure.at_xpath('destination').content
    abbreviation = departure.at_xpath('abbreviation').content

    departure.xpath('estimate').each do |estimate|
      info = {:station => {:name => destination, :abbreviation => abbreviation}}
      %w(minutes platform direction length color hexcolor bikeflag).each do |attribute|
        value = estimate.at_xpath(attribute).content
        info[attribute] = value
      end
      results << info
    end
  end

  json results.sort!{|x,y| x['minutes'].to_i <=> y['minutes'].to_i}
end
