require 'rails_helper'

RSpec.describe NewUserWorker do
  describe '.work' do
    email = 'user@email.com'
    key = 'random key'

    before :each do
      logger = double(Sneakers.logger)
      allow(Sneakers).to receive(:logger).and_return(logger)
      allow(logger).to receive(:info)

      @new_user_worker = NewUserWorker.new

      @account_key_gateway = double(AccountKeyGateway)
      allow(AccountKeyGateway).to receive(:new).and_return(@account_key_gateway)
    end

    it 'calls gateway with email and key' do
      message = {
        email: email,
        key: key
      }.to_json

      account_key_response = AccountKeyResponse.new
      expect(@account_key_gateway).to receive(:account_key_for).with(email, key)
                                        .and_return(account_key_response)

      event_publisher = double(EventPublisher)
      expect(EventPublisher).to receive(:new).with('account_keys', account_key_response)
                                  .and_return(event_publisher)
      expect(event_publisher).to receive(:publish)

      expect(@new_user_worker).to receive(:ack!)

      @new_user_worker.work message
    end

    context 'when there is a gateway error' do
      it 'rejects message' do
        message = {
          email: email,
          key: key
        }.to_json

        expect(@account_key_gateway).to receive(:account_key_for).with(email, key)
                                          .and_raise(GatewayError)

        expect(@new_user_worker).to receive(:reject!)

        @new_user_worker.work message
      end
    end

    context 'when the message is unprocessable' do
      it 'rejects message' do
        message = {
          email: email
        }.to_json

        expect(@new_user_worker).to receive(:reject!)

        @new_user_worker.work message
      end
    end
  end
end