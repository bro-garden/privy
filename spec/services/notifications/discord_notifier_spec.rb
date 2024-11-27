require 'rails_helper'

RSpec.describe Notifications::DiscordNotifier do
  subject(:creator) { described_class.new(message) }

  describe '#notify_message_expiration!' do
    context 'when message exists' do
      let(:message) { create(:message) }
      let(:discord_engine_message) { instance_spy(DiscordEngine::Message) }
      let(:channel_id) { message.external_message.channel_id }
      let(:message_id) { message.external_message.external_id }

      before do
        create(:discord_message, message:)
        message.reload
        allow(DiscordEngine::Message).to receive(:new).and_return(discord_engine_message)
        creator.notify_message_expiration!
      end

      it 'calls DiscordEngine::Message#update' do
        expect(discord_engine_message).to have_received(:update).with(channel_id:, message_id:)
      end
    end
  end
end
