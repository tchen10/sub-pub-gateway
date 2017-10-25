require 'rails_helper'

RSpec.describe V1::UsersApi do
  let(:user_1) { create :user, email: 'user1@email.com' }
  let(:user_2) { create :user, email: 'user2@email.com' }

  describe 'GET /users' do
    it 'calls user search service with query parameter' do
      expect(UserSearchService).to receive(:find).with('query')
                                     .and_return([user_1, user_2])

      get '/v1/users', params: { query: 'query' }

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['users'].count).to eq 2
    end

    it 'returns user with attributes' do
      expect(UserSearchService).to receive(:find).and_return([user_1])

      get '/v1/users'

      expect(response.status).to eq 200
      user_response = JSON.parse(response.body)['users'].first
      expect(user_response.keys).to contain_exactly('email',
                                                    'phone_number',
                                                    'full_name',
                                                    'key',
                                                    'account_key',
                                                    'metadata')
    end

    it 'returns empty array when service does not return users' do
      expect(UserSearchService).to receive(:find).and_return([])

      get '/v1/users'

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['users']).to eq []
    end
  end

  describe 'POST /users' do
    context 'success' do
      it 'calls user creator with declared parameters' do
        params = {
          email: 'user1@gmail.com',
          phone_number: '123456789',
          password: 'secret'
        }

        declared_params = params.merge(:full_name => nil, :metadata => nil)
        expect(UserCreator).to receive(:for)
                                 .with(declared_params)
                                 .and_return(user_1)

        post '/v1/users', params: params

        expect(response.status).to eq 201
        expect(JSON.parse(response.body).keys).to contain_exactly('email',
                                                                  'phone_number',
                                                                  'full_name',
                                                                  'key',
                                                                  'account_key',
                                                                  'metadata')
      end
    end

    context 'failure' do
      it 'returns list of errors when record is invalid' do
        params = {
          email: 'existing email',
          phone_number: '123456789',
          password: 'secret'
        }


        declared_params = params.merge(:full_name => nil, :metadata => nil)
        expect(UserCreator).to receive(:for)
                                 .with(declared_params)
                                 .and_raise(ActiveRecord::RecordInvalid)

        post '/v1/users', params: params

        expect(response.status).to eq 422
        expect(JSON.parse(response.body)).to eq({'errors' => 'Record invalid'})
      end

      it 'returns grape validation error when required params are missing' do
        params = {
          phone_number: '123456789',
          password: 'secret'
        }

        post '/v1/users', params: params

        expect(response.status).to eq 422
        expect(JSON.parse(response.body)).to eq({'errors' => ['email is missing']})
      end
    end
  end
end