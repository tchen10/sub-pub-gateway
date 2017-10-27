class UserKeyWorker
  include Sneakers::Worker
  from_queue 'new_users'

  def work(msg)
    begin
      Rails.logger.info "#{self.class.name}: Received #{msg}"
      message = NewUserMessage.new.create_from_json JSON.parse(msg)
      raise MissingAttributeError unless message.valid?

      response = AccountKeyGateway.new.account_key_for message['email'], ['key']

      EventPublisher.new('account_keys', response)
    rescue GatewayError => gateway
      Rails.logger.info "#{self.class.name}: Failed to retrieve account key for #{email}. Message requeued. #{gateway.message}"
      retry!
    end
  end
end