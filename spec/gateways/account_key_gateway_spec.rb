require 'rails_helper'

RSpec.describe AccountKeyGateway do
  describe '.account_key_For' do
    key = 'secure random key'
    email = 'my@email.com'
    account_key = 'retrieved account key'

    context 'when call to service to successful' do
      it 'creates a valid user when params are valid' do
        body = {
          email: email,
          account_key: account_key
        }.to_json

        response_double = double({ code: 200, body: body })
        expect(AccountKeyGateway).to receive(:post).with('/v1/account', body: { email: email, key: key })
                                       .and_return(response_double)

        expect(UserAccountKeyService).to receive(:update).with(email, account_key)

        AccountKeyGateway.new.account_key_for(email, key)
      end
    end

    context 'when service returns unprocessable body' do
      it 'raises gateway error when no account key is provided' do
        body = {
          email: email,
          errors: 'Service is unreachable'
        }.to_json

        response_double = double({ code: 200, body: body })
        expect(AccountKeyGateway).to receive(:post).with('/v1/account', body: { email: email, key: key })
                                       .and_return(response_double)


        expect{ AccountKeyGateway.new.account_key_for(email, key) }.to raise_error GatewayError
      end

      it 'raises gateway error when no email is provided' do
        body = {
          account_key: account_key,
          errors: 'Service is unreachable'
        }.to_json

        response_double = double({ code: 200, body: body })
        expect(AccountKeyGateway).to receive(:post).with('/v1/account', body: { email: email, key: key })
                                       .and_return(response_double)


        expect{ AccountKeyGateway.new.account_key_for(email, key) }.to raise_error GatewayError
      end
    end

    context 'when service returns an error code' do
      it 'raises gateway error' do
        response_double = double({ code: 500, body: 'error' })
        expect(AccountKeyGateway).to receive(:post).with('/v1/account', body: { email: email, key: key })
                                       .and_return(response_double)

        expect{ AccountKeyGateway.new.account_key_for(email, key) }.to raise_error GatewayError
      end
    end
  end
end