require 'rails_helper'

RSpec.describe UserCreator do
  describe '#for' do
    secure_key = 'secure random key'
    secure_password = 'super secret'
    email = 'new@email.com'

    it 'creates a valid user when params are valid' do
      expect(SecureRandom).to receive(:base64).with(12).and_return(secure_key)
      expect(BCrypt::Password).to receive(:create).with('secret').and_return(secure_password)
      expect(UserAccountKeyService).to receive(:request_account_key).with(email, secure_key)

      params = {
        email: email,
        phone_number: '123456789',
        password: 'secret',
        full_name: 'new user',
        metadata: 'data about user'
      }

      new_user = UserCreator.for(params)

      expect(User.all.count).to eq 1

      expect(new_user.email).to eq email
      expect(new_user.phone_number).to eq params[:phone_number]
      expect(new_user.key).to eq secure_key
      expect(new_user.password).to eq secure_password
      expect(new_user.full_name).to eq params[:full_name]
      expect(new_user.metadata).to eq params[:metadata]
    end

    context 'when creation fails' do
      params = {
        email: 'new@email.com',
        password: 'secret'
      }

      it 'raises record invalid error for invalid parameters ' do
        expect { UserCreator.for(params) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not call user account key service if creation fails' do
        expect(UserAccountKeyService).not_to receive(:request_account_key)
        expect { UserCreator.for(params) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end