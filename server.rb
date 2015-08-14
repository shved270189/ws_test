require 'sinatra'
require 'sinatra/reloader' if development?
require './config/initialize/server'

set :server, :thin
enable :sessions

rabbit = Rabbit.new
channel = rabbit.channel
queue_broadcast = channel.queue('broadcast')

helpers do
  def authorize!
    redirect(to('/login')) unless @current_user
  end
end

before do
  @current_user = User.where(id: session['user_id']).first
end

get '/login' do
  erb :login
end

post '/sessions' do
  user = User.where(login: params['login'], password: params['password']).first
  session['user_id'] = user.id if user
  redirect to('/')
end

get '/registration' do
  erb :registration
end

post '/users' do
  unless User.where(login: params['login']).first
    user = User.create(login: params['login'], password: params['password'])
    session['user_id'] = user.id if user
  end
  redirect to('/')
end

get '/logout' do
  session['user_id'] = nil
  redirect to('/')
end

get '/' do
  authorize!

  erb :index
end

post '/send' do
  data = JSON.generate(user_name: params['user_name'],
                       message: params['message'])
  channel.default_exchange.publish(data, routing_key: queue_broadcast.name)
  data
end
