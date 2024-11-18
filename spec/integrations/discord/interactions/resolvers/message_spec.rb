require 'rails_helper'

RSpec.describe Discord::Interactions::Resolvers::Message do
  subject(:message_resolver) { described_class.new(context:) }

  let(:context) { DiscordEngine::Resolvers::Context.new(params:) }
  let(:params) { load_json('interactions/message.json') }
  let(:interface) { create(:interface, source: :discord_guild, external_id: context.guild.id) }
  let(:discord_message) { instance_double(DiscordEngine::Message, create: true) }

  before do
    interface # ensure interface exists
    allow(DiscordEngine::Message).to receive(:new).and_return(discord_message)
    allow(discord_message).to receive(:create)
  end

  describe '#execute_action' do
    context 'when message creation succeeds' do
      before do
        message_resolver.execute_action
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

      it 'sends the message to the channel' do
        expect(discord_message).to have_received(:create)
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
    end

    context 'when message creation fails' do
      let(:messages_creator) { instance_double(Messages::Creator) }

      before do
        allow(Messages::Creator).to receive(:new).and_return(messages_creator)
        allow(messages_creator).to receive(:call).and_raise(Messages::CreationFailed, 'Error message')
        message_resolver.execute_action
      end

      it 'sets error content' do
        expect(message_resolver.content).to eq('⚠️ Could not create message: Error message')
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
    end
  end
end
