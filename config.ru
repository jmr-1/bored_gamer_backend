# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'rack/cors'

run Rails.application


require 'rack/cors'
use Rack::Cors do

  allow do
    origins 'https://bored-gamer-meetup.herokuapp.com/'
    resource '*', 
        :headers => :any, 
        :methods => [:get, :post, :delete, :put, :options]
  end
end