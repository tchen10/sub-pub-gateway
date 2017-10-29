require 'rails_helper'

RSpec.describe EventPublisher do
  describe '.publish' do
    test_event = { 'hello': 'world' }

    before :each do
      @mock_bunny = BunnyMock.new
      allow(Bunny).to receive(:new).and_return(@mock_bunny)


      EventPublisher.new('test.queue', test_event).publish
    end

    it 'binds exchange to the correct queue' do
      exchange = @mock_bunny.exchanges['integration-gateway']
      queue = @mock_bunny.queues['test.queue']

      expect(queue.bound_to? exchange).to eq true
    end

    it 'publishes the event to queue with expected options' do
      queue = @mock_bunny.queues['test.queue']
      expect(queue.message_count).to eq 1

      last_message = queue.all.first

      expect(last_message[:message]).to eq test_event.to_json
      expect(last_message[:options][:routing_key]).to eq 'test.queue'
      expect(last_message[:options][:exchange]).to eq 'integration-gateway'
    end
  end
end