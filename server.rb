require 'sinatra'
require 'sinatra/reloader' if development?
require './rabbit'
require 'json'

set :server, :thin

rabbit = Rabbit.new
channel = rabbit.channel
queue_broadcast = channel.queue('broadcast')

get '/' do
  erb :index
end

post '/send' do
  data = JSON.generate({ user_name: params['user_name'], message: params['message'] })
  channel.default_exchange.publish(data, :routing_key => queue_broadcast.name)
  data
end


