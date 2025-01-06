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
    let(:params) { load_json('interactions/message.json') }

    context 'when message creation succeeds' do
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
        expect(message_resolver.notice.content).to eq(Discord::StatusNotices::Created::CONTENT)
      end

      it 'sets empty components array' do
        expect(message_resolver.notice.components).to eq([])
      end

      it 'sets ephemeral flag' do
        expect(message_resolver.flags).to eq(DiscordEngine::Message::EPHEMERAL_FLAG)
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

    context 'when bot has no permission to send messages' do
      let(:message_resource_isntance) { instance_double(DiscordEngine::Message) }
      let(:expected_resolver_message) { Discord::StatusNotices::Unauthorized::CONTENT }
      let(:notice) { instance_double(DiscordEngine::Message, content: expected_resolver_message, components: []) }
      let(:status_notice) { instance_double(Discord::StatusNotices::Unauthorized, build: notice) }

      before do
        allow(DiscordEngine::Message).to receive(:new).and_return(message_resource_isntance)
        allow(message_resource_isntance).to receive(:create).and_raise(Discordrb::Errors::NoPermission)
        allow(Discord::StatusNotices::Unauthorized).to receive(:new).and_return(status_notice)
        message_resolver.execute_action
      end

      it_behaves_like 'message resolver failed'
    end

    context 'when DiscordMessage creation fails' do
      let(:discord_messages_creator) { instance_double(DiscordMessages::Creator) }
      let(:expected_resolver_message) { "⚠️ Could not create message: External can't be blank, Channel can't be blank" }

      before do
        allow(Discordrb::API).to receive(:request).and_return(instance_double(RestClient::Response, body: '{}'))
        allow(discord_messages_creator).to receive(:call).and_raise(
          Messages::CreationFailed,
          "External can't be blank, Channel can't be blank"
        )
        message_resolver.execute_action
      end

      it_behaves_like 'message resolver failed'
    end
  end
end
