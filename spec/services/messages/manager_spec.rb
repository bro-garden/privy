require 'rails_helper'

RSpec.describe Messages::Manager do
  subject { described_class.new(message) }

  let(:message) { create(:message, content:, expiration_limit:, expiration_type:, read:) }
  let(:expiration_limit) { 1 }
  let(:content) { 'Hello, World!' }
  let(:read) { false }

  describe '#read_or_expires_message' do
    context 'when message is read' do
      let(:read) { true }
      let(:expiration_type) { %w[hour hours day weeks month visit].sample }

      it 'returns described_class::EXPIRED' do
        expect(subject.read_or_expires_message).to eq(described_class::EXPIRED)
      end
    end

    context 'when message has time based expiration' do
      let(:expiration_type) { %w[hour hours day days].sample }

      context 'when message has expired' do
        let(:created_at) { Time.current.utc - 3.days }
        before { message.update_column(:created_at, created_at) }

        it 'returns described_class::EXPIRED' do
          expect(subject.read_or_expires_message).to eq(described_class::EXPIRED)
        end

        it 'marks the message as read' do
          expect { subject.read_or_expires_message }.to change { message.read }.from(false).to(true)
        end

        it 'clears the message content' do
          expect { subject.read_or_expires_message }.to change { message.content }.to('')
        end
      end

      context 'when message has not expired' do
        it 'returns the message content' do
          expect(subject.read_or_expires_message).to eq(message.content)
        end

        it 'increments the message visits count' do
          expect { subject.read_or_expires_message }.to change { message.message_visits.count }.by(1)
        end

        it 'does not mark the message as read' do
          expect { subject.read_or_expires_message }.not_to(change { message.read })
        end
      end
    end

    context 'when message has visits based expiration' do
      let(:expiration_type) { %w[visit visits].sample }

      context 'when message has expired' do
        before { create(:message_visit, message:) }

        it 'returns described_class::EXPIRED' do
          expect(subject.read_or_expires_message).to eq(described_class::EXPIRED)
        end

        it 'marks the message as read' do
          expect { subject.read_or_expires_message }.to change { message.read }.from(false).to(true)
        end

        it 'clears the message content' do
          expect { subject.read_or_expires_message }.to change { message.content }.to('')
        end
      end

      context 'when message has not expired' do
        it 'returns the message content' do
          expect(subject.read_or_expires_message).to eq(message.content)
        end

        it 'increments the message visits count' do
          expect { subject.read_or_expires_message }.to change { message.message_visits.count }.by(1)
        end

        it 'does not mark the message as read' do
          expect { subject.read_or_expires_message }.not_to(change { message.read })
        end
      end
    end
  end
end
