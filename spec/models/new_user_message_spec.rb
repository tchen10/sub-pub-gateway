require 'rails_helper'

RSpec.describe NewUserMessage, type: :model do
  describe 'validations' do
    it 'validates presence of key' do
      message = {
        email: 'user@email.com'
      }.to_json

      new_user_message = NewUserMessage.new.create_from_json(message)

      expect(new_user_message.valid?).to be false
    end

    it 'validates presence of email' do
      message = {
        key: 'new key'
      }.to_json

      new_user_message = NewUserMessage.new.create_from_json(message)

      expect(new_user_message.valid?).to be false
    end
  end

  describe '.create_from_json' do
    it 'parses json and sets values' do
      message = {
        email: 'user@email.com',
        key: 'new key'
      }.to_json

      new_user_message = NewUserMessage.new.create_from_json(message)

      expect(new_user_message.email).to eq 'user@email.com'
      expect(new_user_message.key).to eq 'new key'
    end
  end
end
