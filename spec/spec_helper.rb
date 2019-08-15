## Take a look at this receipt http://recipes.sinatrarb.com/p/testing/rspec?

require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../main.rb', __FILE__

module RSpecMixin
    include Rack::Test::Methods

    # If your app was defined using the modular style, use
    #    def app() described_class end
    # instead of 
    #    def app() Sinatra::Application end
    def app 
        Sinatra::Application 
    end
end

RSpec.configure do |c| 
    c.include RSpecMixin 
end