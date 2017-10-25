require 'rails_helper'

RSpec.describe UserSearchService do
  describe '#find' do
    before :each do
      create :user, email: 'michael@email.com', full_name: 'Michael Scott', metadata: 'best, boss'
      create :user, email: 'dwight@email.com', full_name: 'Dwight Shrute', metadata: 'beets, bears'
    end

    context 'search with query' do
      it 'returns users where metadata contains query' do
        users = UserSearchService.find 'beets'

        expect(users.count).to eq 1
        expect(users.first.metadata).to eq 'beets, bears'
      end

      it 'returns users where email contains query' do
        users = UserSearchService.find 'dwight'

        expect(users.count).to eq 1
        expect(users.first.email).to eq 'dwight@email.com'
      end

      it 'returns users where full name contains query' do
        users = UserSearchService.find 'Dwight'

        expect(users.count).to eq 1
        expect(users.first.full_name).to eq 'Dwight Shrute'
      end

      it 'returns empty array when no fields contain query' do
        users = UserSearchService.find 'scranton'

        expect(users).to eq []
      end
    end

    context 'search without query' do
      it 'returns all users' do
        users = UserSearchService.find

        expect(users.count).to eq 2
      end
    end
  end
end