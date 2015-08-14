require 'mongoid'

Mongoid.load!('./config/mongoid.yml', :development)

require './models/user'
