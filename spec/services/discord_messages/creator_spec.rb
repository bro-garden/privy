require 'rails_helper'

RSpec.describe DiscordMessages::Creator do
  subject(:creator) { described_class.new(params: discord_api_response_body, message_id:) }

  describe '#call' do
    let(:discord_api_response_body) do
      load_cassette_response('resolvers/messages/create_discord_message')
    end

    context 'when message exists' do
      let(:message_id) { create(:message).id }

      it 'creates a discord message' do
        expect { creator.call }.to change(DiscordMessage, :count).by(1)
      end

      it 'returns true' do
        expect(creator.call).to be(true)
      end

      it 'creates a DiscordMessage instance in discord_message attribute' do
        creator.call
        expect(creator.discord_message).to be_instance_of(DiscordMessage)
      end

      it 'adds the discord message to the message' do
        creator.call
        expect(Message.find(message_id).external_message).to eq(creator.discord_message)
      end
    end

    context 'when message does not exist' do
      let(:message_id) { 0 }

      it 'raises an error' do
        expect { creator.call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
