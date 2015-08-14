require 'em-websocket'
require './rabbit'

clients = []

rabbit = Rabbit.new
channel = rabbit.channel
queue_broadcast = channel.queue('broadcast')
queue_broadcast.subscribe do |_delivery_info, _properties, body|
  clients.each { |client| client.send(body) }
end

EM.run do
  EM::WebSocket.run(host: 'localhost', port: 8080) do |ws|
    ws.onopen do |_handshake|
      clients << ws

      puts "WebSocket connection open. Online clients: #{clients.count}"
    end

    ws.onclose do
      clients.delete(ws)

      puts "WebSocket connection closed. Online clients: #{clients.count}"
    end
  end
end
