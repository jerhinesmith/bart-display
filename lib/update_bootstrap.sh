#!/bin/bash

PROJECT_HOME="/Users/jrhinesmith/projects/bart-display"
mkdir -p $PROJECT_HOME/tmp
rm -rf $PROJECT_HOME/tmp/bootstrap
rm $PROJECT_HOME/tmp/bootstrap.zip
curl -o $PROJECT_HOME/tmp/bootstrap.zip http://twitter.github.com/bootstrap/assets/bootstrap.zip
unzip $PROJECT_HOME/tmp/bootstrap.zip -d $PROJECT_HOME/tmp
rm $PROJECT_HOME/tmp/bootstrap.zip
rm -rf $PROJECT_HOME/public/bootstrap
mv $PROJECT_HOME/tmp/bootstrap/ $PROJECT_HOME/public