require 'rails_helper'

RSpec.describe Messages::Expirer do
  subject(:expirer) { described_class.new(message) }

  describe '#call' do
    let(:interface) { create(:interface, source: 'api') }
    let(:message) { create(:message, interface:) }

    it 'broadcasts privy_message_expired event' do
      expect { expirer.call }
        .to broadcast(:privy_message_expired, { message: })
    end

    context 'when message is from internal interface' do
      let(:interface) { create(:interface, source: 'api') }

      it 'expires message' do
        expect { expirer.call }.to change { message.reload.expired }.from(false).to(true)
      end

      it 'adds expired_at timestamp' do
        expect { expirer.call }.to change { message.reload.expired_at }.from(nil)
      end
    end

    context 'when message is from discord_guild' do
      let(:interface) { create(:interface, source: 'discord_guild') }
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
  end
end
