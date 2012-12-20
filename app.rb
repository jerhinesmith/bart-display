require 'rubygems'
require 'sinatra'
require 'haml'
require 'yajl'
require 'sinatra/json'
require 'nokogiri'
require 'open-uri'

BART_API_KEY = 'EXH4-PDS6-5Z49-YIYU'
WUNDERGROUND_API_KEY = 'ebea330e1168cfb6'

get '/' do
  @station = params[:station] || 'powl'
  @weather_city = params[:weather_city] || 'San_Francisco'
  @weather_state = params[:weather_state] || 'CA'
  haml :index
end

get '/setup' do
  @bart_stations = [
    ['12th St. Oakland City Center', '12th'],
    ['16th St. Mission (SF)', '16th'],
    ['19th St. Oakland', '19th'],
    ['24th St. Mission (SF)', '24th'],
    ['Ashby (Berkeley)', 'ashb'],
    ['Balboa Park (SF)', 'balb'],
    ['Bay Fair (San Leandro)', 'bayf'],
    ['Castro Valley', 'cast'],
    ['Civic Center (SF)', 'civc'],
    ['Coliseum/Oakland Airport', 'cols'],
    ['Colma', 'colm'],
    ['Concord', 'conc'],
    ['Daly City', 'daly'],
    ['Downtown Berkeley', 'dbrk'],
    ['Dublin/Pleasanton', 'dubl'],
    ['El Cerrito del Norte', 'deln'],
    ['El Cerrito Plaza', 'plza'],
    ['Embarcadero (SF)', 'embr'],
    ['Fremont', 'frmt'],
    ['Fruitvale (Oakland)', 'ftvl'],
    ['Glen Park (SF)', 'glen'],
    ['Hayward', 'hayw'],
    ['Lafayette', 'lafy'],
    ['Lake Merritt (Oakland)', 'lake'],
    ['MacArthur (Oakland)', 'mcar'],
    ['Millbrae', 'mlbr'],
    ['Montgomery St. (SF)', 'mont'],
    ['North Berkeley', 'nbrk'],
    ['North Concord/Martinez', 'ncon'],
    ['Orinda', 'orin'],
    ['Pittsburg/Bay Point', 'pitt'],
    ['Pleasant Hill', 'phil'],
    ['Powell St. (SF)', 'powl'],
    ['Richmond', 'rich'],
    ['Rockridge (Oakland)', 'rock'],
    ['San Bruno', 'sbrn'],
    ['San Francisco Int''l Airport', 'sfia'],
    ['San Leandro', 'sanl'],
    ['South Hayward', 'shay'],
    ['South San Francisco', 'ssan'],
    ['Union City', 'ucty'],
    ['Walnut Creek', 'wcrk'],
    ['West Oakland', 'woak']
  ]
  haml :setup
end

get '/next/:station.json' do |station|
  doc = Nokogiri::HTML(open("http://api.bart.gov/api/etd.aspx?cmd=etd&orig=#{station}&key=#{BART_API_KEY}"))

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
