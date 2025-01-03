require 'rails_helper'

RSpec.describe Messages::Reader do
  subject(:reader) { described_class.new(message) }

  let(:message) { create(:message, :from_discord, content:, expiration_limit:, expiration_type:, expired:) }
  let(:expiration_limit) { 1 }
  let(:content) { 'Hello, World!' }
  let(:expired) { false }
  let(:visibility_time) { 1 }
  let(:resolver_name) { 'reveal_message' }
  let(:discord_engine_message) { instance_double(DiscordEngine::Message, content:, components: [], update: true) }

  before do
    allow(DiscordEngine::Message).to receive(:new).and_return(discord_engine_message)
  end

  describe '#read_message' do
    context 'when message expiration is time based' do
      subject(:read_message) { reader.read_message }

      let(:expiration_type) { 'day' }

      it 'broadcasts message_read event' do
        expect { read_message }
          .to broadcast(:privy_message_read, { message: })
      end

      context 'when message is expired' do
        before do
          message.update(created_at: 2.days.ago)
        end

        it 'raises an error' do
          expect { read_message }.to raise_error(Messages::ExpiredError)
        end
      end

      context 'when message is not expired' do
        it 'returns ActionText::EncryptedRichText' do
          expect(read_message).to be_a(ActionText::EncryptedRichText)
        end

        it 'returns message content' do
          expect(read_message.to_plain_text).to eq(content)
        end

        it 'creates a message visit' do
          expect { read_message }.to change(MessageVisit, :count).by(1)
        end
      end
    end

    context 'when message expiration is visit based' do
      subject(:read_message) { reader.read_message }

      let(:expiration_type) { 'visit' }

      context 'when message is expired' do
        before do
          create_list(:message_visit, expiration_limit, message:)
        end

        it 'raises an error' do
          expect { read_message }.to raise_error(Messages::ExpiredError)
        end
      end

      context 'when message is not expired' do
        it 'returns ActionText::EncryptedRichText' do
          expect(read_message).to be_a(ActionText::EncryptedRichText)
        end

        it 'returns message content' do
          expect(read_message.to_plain_text).to eq(content)
        end

        it 'creates a message visit' do
          expect { read_message }.to change(MessageVisit, :count).by(1)
        end
      end
    end
  end
end
