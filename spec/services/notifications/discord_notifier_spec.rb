require 'rails_helper'

RSpec.describe Notifications::DiscordNotifier do
  subject(:creator) { described_class.new(message) }

  let(:discord_engine_message) { instance_spy(DiscordEngine::Message) }
  let(:channel_id) { message.external_message.channel_id }
  let(:message_id) { message.external_message.external_id }

  before do
    create(:discord_message, message:)
    message.reload
    allow(DiscordEngine::Message).to receive(:new).and_return(discord_engine_message)
  end

  describe '#notify_message_expiration!' do
    let(:message) { create(:message) }

    before do
      creator.notify_message_expiration!
    end

    it 'calls DiscordEngine::Message#update' do
      expect(discord_engine_message).to have_received(:update).with(
        channel_id:,
        message_id:
      )
    end
  end

  describe '#notify_message_state!' do
    let(:message) { create(:message, expiration_limit:, expiration_type:) }

    context 'when message is still available' do
      let(:resolver_name) { 'resolver_name' }
      let(:expiration_limit) { 1 }
      let(:expiration_type) { 'hour' }

      before do
        creator.notify_message_state!(resolver_name)
      end

      it 'calls DiscordEngine::Message#update' do
        expect(discord_engine_message).to have_received(:update).with(
          channel_id:,
          message_id:
        )
      end
    end

    context 'when message is expired' do
      let(:resolver_name) { 'resolver_name' }
      let(:expiration_limit) { 1 }
      let(:expiration_type) { 'visit' }
      let(:expirer_isntance) { instance_spy(Messages::Expirer) }

      before do
        allow(Messages::Expirer).to receive(:new).and_return(expirer_isntance)
        create(:message_visit, message:)
        creator.notify_message_state!(resolver_name)
      end

      it 'calls Messages::Expirer#call' do
        expect(expirer_isntance).to have_received(:call)
      end
    end
  end
end
