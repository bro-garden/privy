require 'rails_helper'

RSpec.describe Messages::CheckMessageExpirationListener do
  subject(:listener) { described_class.new }

  describe '#privy_message_read' do
    let(:interface) { create(:interface, source:) }
    let(:message) do
      Timecop.freeze(created_at) do
        message = create(:message,
                         interface:,
                         expiration_type: :hour,
                         expiration_limit: 1,
                         expired: false)
        message.content.update!(body: 'Test message')
        message
      end
    end
    let(:source) { :api }
    let(:created_at) { 2.hours.ago }
    let(:payload) { { message: } }

    context 'when message is not available and interface is internal' do
      it 'expires the message' do
        expect { listener.privy_message_read(payload) }
          .to change { message.reload.expired }.from(false).to(true)
      end

      it 'sets expired_at' do
        expect { listener.privy_message_read(payload) }
          .to change { message.reload.expired_at }.from(nil)
      end

      it 'blanks the message content' do
        expect { listener.privy_message_read(payload) }
          .to change { message.reload.content.body }.to(nil)
      end
    end

    context 'when message is available' do
      let(:created_at) { 30.minutes.ago }

      it 'does not expire the message' do
        expect { listener.privy_message_read(payload) }
          .not_to(change { message.reload.expired })
      end
    end

    context 'when interface is not internal' do
      let(:source) { :discord_guild }

      it 'does not expire the message' do
        expect { listener.privy_message_read(payload) }
          .not_to(change { message.reload.expired })
      end
    end
  end
end
