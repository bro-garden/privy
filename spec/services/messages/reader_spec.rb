require 'rails_helper'

RSpec.describe Messages::Reader do
  subject(:reader) { described_class.new(message) }

  let(:message) { create(:message, content:, expiration_limit:, expiration_type:, read:) }
  let(:expiration_limit) { 1 }
  let(:content) { 'Hello, World!' }
  let(:read) { false }

  describe '#read_message' do
    context 'when message expiration is time based' do
      let(:expiration_type) { 'day' }

      context 'when message is expired' do
        subject { reader.read_message }

        before do
          message.update(created_at: 2.days.ago)
        end

        it 'raises an error' do
          expect { subject }.to raise_error(Messages::ExpiredError)
        end
      end

      context 'when message is not expired' do
        subject { reader.read_message }

        it 'returns message content' do
          expect(subject).to eq(content)
        end

        it 'creates a message visit' do
          expect { subject }.to change(MessageVisit, :count).by(1)
        end
      end
    end

    context 'when message expiration is visit based' do
      let(:expiration_type) { 'visit' }

      context 'when message is expired' do
        subject { reader.read_message }

        before do
          create_list(:message_visit, expiration_limit, message:)
        end

        it 'raises an error' do
          expect { subject }.to raise_error(Messages::ExpiredError)
        end
      end

      context 'when message is not expired' do
        subject { reader.read_message }

        it 'returns message content' do
          expect(subject).to eq(content)
        end

        it 'creates a message visit' do
          expect { subject }.to change(MessageVisit, :count).by(1)
        end
      end
    end
  end
end
