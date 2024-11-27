require 'rails_helper'

RSpec.describe Messages::Expirer do
  subject(:expirer) { described_class.new(message_id) }

  describe '#call' do
    context 'when message exists' do
      let(:message) { create(:message, interface: create(:interface, source: 'api')) }
      let(:message_id) { message.id }

      it 'expires message' do
        expect { expirer.call }.to change { message.reload.expired }.from(false).to(true)
      end

      it 'adds expired_at timestamp' do
        expect { expirer.call }.to change { message.reload.expired_at }.from(nil)
      end
    end

    context 'when message is from discord_guild' do
      let(:message) { create(:message, interface: create(:interface, source: 'discord_guild')) }
      let(:message_id) { message.id }
      let(:discord_messages_notifier) { instance_spy(Notifications::DiscordNotifier) }

      before do
        create(:discord_message, message:)
        allow(Notifications::DiscordNotifier).to receive(:new).and_return(discord_messages_notifier)
        expirer.call
      end

      it 'notifies message expiration' do
        expect(discord_messages_notifier).to have_received(:notify_message_expiration!)
      end
    end

    context 'when message does not exist' do
      let(:message_id) { 0 }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { expirer.call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
