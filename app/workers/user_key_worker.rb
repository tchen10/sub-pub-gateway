class UserKeyWorker
  include Sneakers::Worker
  from_queue 'new_users'

  def work(msg)
    begin
      Rails.logger.info "#{self.class.name}: Received #{msg}"
      message = JSON.parse(msg)
      raise MissingAttributeError if message['email'].nil? || message['account_key'].nil?

      response = AccountKeyGateway.new.account_key_for message['email'], ['key']
      # publish response
    rescue GatewayError => gateway
      Rails.logger.info "#{self.class.name}: Failed to retrieve account key for #{email}. Retry in 10 minutes: #{gateway.message}"
      retry!
    end
  end
end