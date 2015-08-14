require 'bunny'

# for RabbitMQ
class Rabbit
  def initialize
    @connection = Bunny.new
    @connection.start
  end

  def channel
    @channel ||= @connection.create_channel
  end
end
