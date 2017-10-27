class AccountKeyGateway
  include HTTParty

  base_uri ENV['ACCOUNT_KEY_SERVICE']

  def account_key_for(email, key)
    body = {
      email: email,
      key: key
    }

    Rails.logger.info "AccountKeyGateway#POST with #{body}"
    response = self.class.post('/v1/account', body: body)

    case response.code
      when (200..201)
        response_body = AccountKeyResponse.new.create_from_json(JSON.parse(response.body))
        raise GatewayError.new(self.class.name, response.inspect) unless response_body.valid?
        return response_body
      else
        raise GatewayError.new(self.class.name, response.inspect)
    end
  end
end