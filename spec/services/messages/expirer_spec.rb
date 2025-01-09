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

      it 'clears content' do
        expect { expirer.call }.to change { message.reload.content.body }.from(message.content.body).to(nil)
      end
    end
  end
end
