require 'rails_helper'

RSpec.describe Discord::Interactions::Resolvers::Message do
  subject(:message_resolver) { described_class.new(context:) }

  let(:context) { DiscordEngine::Resolvers::Context.new(params:) }
  let(:interface) { create(:interface, source: :discord_guild, external_id: context.guild.id) }

  before do
    interface # ensure interface exists
    allow(DiscordEngine::Message).to receive(:new).and_call_original
  end

  describe '#execute_action', :vcr do
    context 'when message creation succeeds' do
      let(:params) { load_json('interactions/message.json') }

      before do
        VCR.use_cassette('resolvers/messages/create_discord_message') do
          message_resolver.execute_action
        end
      end

      it 'adds a DiscordEngine::InteractionCallback instance to callback attribute' do
        expect(message_resolver.callback).to be_an_instance_of(DiscordEngine::InteractionCallback)
      end

      it 'adds a callback of right type' do
        expect(message_resolver.callback.type)
          .to be(DiscordEngine::InteractionCallback::CHANNEL_MESSAGE_WITH_SOURCE_TYPE)
      end

      it 'sets success content' do
        expect(message_resolver.content).to eq('✅ Message created!')
      end

      it 'sets empty components array' do
        expect(message_resolver.components).to eq([])
      end

      it 'sets ephemeral flag' do
        expect(message_resolver.flags).to eq(DiscordEngine::Message::EPHEMERAL_FLAG)
      end

      it 'creates a message in the channel' do
        expect(DiscordEngine::Message).to have_received(:new)
          .with(
            content: described_class::MESSAGE_CREATED_CONTENT,
            components: [kind_of(DiscordEngine::MessageComponents::ActionRow)]
          )
      end

      it 'creates a message record' do
        expect(Message.count).to eq(1)
      end

      it 'associates the message with the correct interface' do
        expect(Message.last.interface).to eq(interface)
      end

      it 'sets the correct content on the message' do
        expect(Message.last.content.to_plain_text).to eq(context.option_value('content'))
      end

      it 'sets the correct expiration limit on the message' do
        expect(Message.last.expiration_limit).to eq(context.option_value('expiration_limit'))
      end

      it 'sets the correct expiration type on the message' do
        expect(Message.last.expiration_type).to eq(context.option_value('expiration_type'))
      end

      it 'creates a DiscordMessage record' do
        expect(DiscordMessage.count).to eq(1)
      end
    end

    context 'when message creation fails' do
      let(:params) { load_json('interactions/message_invalid.json') }

      before do
        VCR.use_cassette('resolvers/messages/create_discord_message_failed') do
          message_resolver.execute_action
        end
      end

      it 'sets error content' do
        expect(message_resolver.content).to include('⚠️ Could not create message')
      end

      it 'still sets the callback' do
        expect(message_resolver.callback).to be_an_instance_of(DiscordEngine::InteractionCallback)
      end

      it 'sets empty components array' do
        expect(message_resolver.components).to eq([])
      end

      it 'sets ephemeral flag' do
        expect(message_resolver.flags).to eq(DiscordEngine::Message::EPHEMERAL_FLAG)
      end

      it 'does not create a message in the database' do
        expect(Message.count).to eq(0)
      end

      it 'does not create a DiscordMessage record' do
        expect(DiscordMessage.count).to eq(0)
      end
    end
  end
end
