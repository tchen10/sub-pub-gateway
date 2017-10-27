class NewUserWorker
  include Sneakers::Worker
  from_queue 'new_users',
             { :arguments => {:'x-dead-letter-exchange' => 'new_users-retry'} }

  def work(msg)
    begin
      Sneakers.logger.info "#{self.class.name} Received #{msg}."
      message = NewUserMessage.new.create_from_json msg
      raise MissingAttributeError unless message.valid?

      response = AccountKeyGateway.new.account_key_for message.email, message.key

      EventPublisher.new('account_keys', response)
      ack!
    rescue MissingAttributeError => e
      Sneakers.logger.info "#{self.class.name} Message received is missing required attributes. #{msg}"
      reject!
    rescue GatewayError => gateway
      Sneakers.logger.info "#{self.class.name} Failed to retrieve account key. Message requeued. #{gateway.message}"
      reject!
    rescue Bunny::TCPConnectionFailed => e
      Sneakers.logger.info "#{self.class.name} Connection to message queue at #{ENV['MESSAGE_QUEUE_URL']} failed. #{e}"
      reject!
    rescue Bunny::PossibleAuthenticationFailureError => e
      Sneakers.logger.info "#{self.class.name} Connection to message queue at #{ENV['MESSAGE_QUEUE_URL']} failed. #{e}"
      reject!
    end
  end
end