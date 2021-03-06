class EventPublisher
  def initialize(queue_name, event)
    @queue_name = queue_name
    @event = event
  end

  def publish
    exchange = channel.direct 'integration-gateway'
    queue = channel.queue(@queue_name, :durable => true).bind(exchange, :routing_key => @queue_name)
    exchange.publish(@event.to_json, { :routing_key => queue.name,
                                       :content_type => 'application/json' })
    @connection.close
  end

  def channel
    @channel ||= connection.create_channel
  end

  def connection
    @connection = Bunny.new(ENV['MESSAGE_QUEUE_URL'])
    @connection.start
  end
end