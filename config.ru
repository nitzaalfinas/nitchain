require 'rubygems'
require 'bundler'

Bundler.require

ENV = "development"

require './main'

run Sinatra::Application
