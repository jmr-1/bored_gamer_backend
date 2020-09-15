# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'rack/cors'

run Rails.application

# use Rack::Cors do

#   allow do
#     # origins ['https://bored-gamer-meetup.herokuapp.com', 'http://localhost:3000']
#     origins '*'
#     resource '*', 
#         :headers => :any, 
#         :methods => [:get, :post, :delete, :put, :options]
#   end
# end