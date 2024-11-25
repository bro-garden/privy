require 'rails_helper'

RSpec.describe Discord::Interactions::Resolvers::RevealMessage do
  subject(:message_resolver) { described_class.new(context:) }

  let(:context) { DiscordEngine::Resolvers::Context.new(params:) }
  let(:interface) { create(:interface, source: :discord_guild, external_id: context.guild.id) }

  before do
    interface # ensure interface exists
    allow(DiscordEngine::Message).to receive(:new).and_call_original
  end

  describe '#execute_action', :vcr do
    let(:params) do
      read = load_json('interactions/reveal_message.json')
      # "{\"resolver_name\":\"reveal_message\",\"data\":{\"message_id\":12}}"
      read['data']['custom_id'] = "{\"resolver_name\":\"reveal_message\",\"data\":{\"message_id\":#{message_id}}}"

      read
    end

    context 'when message relevation succeeds' do
      let(:message) { create(:message) }
      let(:message_id) { message.id }

      before do
        message_resolver.execute_action
      end

      it 'adds a DiscordEngine::InteractionCallback instance to callback attribute' do
        expect(message_resolver.callback).to be_an_instance_of(DiscordEngine::InteractionCallback)
      end

      it 'adds a callback of right type' do
        expect(message_resolver.callback.type)
          .to be(DiscordEngine::InteractionCallback::UPDATE_MESSAGE_TYPE)
      end

      it 'sets success content' do
        expect(message_resolver.content).to eq(message.content.to_plain_text)
      end

      it 'sets empty components array' do
        expect(message_resolver.components).to eq([])
      end
    end
  end
end
