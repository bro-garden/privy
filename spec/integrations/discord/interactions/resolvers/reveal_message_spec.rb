require 'rails_helper'

RSpec.describe Discord::Interactions::Resolvers::RevealMessage do
  subject(:message_resolver) { described_class.new(context:) }

  let(:context) { DiscordEngine::Resolvers::Context.new(params:) }
  let(:interface) { create(:interface, source: :discord_guild, external_id: context.guild.id) }

  before do
    interface # ensure interface exists
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

      it 'sets success content' do
        expect(message_resolver.content).to eq(message.content.to_plain_text)
      end

      it_behaves_like 'reval message basics'
    end

    context 'when message does not exist' do
      let(:message_id) { 0 }

      before do
        message_resolver.execute_action
      end

      it 'sets error content' do
        expect(message_resolver.content).to eq('⚠️ Could not find the message')
      end

      it_behaves_like 'reval message basics'
    end

    context 'when message has expired' do
      let(:message) { create(:message, expiration_limit: 1, expiration_type: 'visit') }
      let(:message_id) { message.id }

      before do
        create_list(:message_visit, 1, message:)
        message_resolver.execute_action
      end

      it 'sets error content' do
        expect(message_resolver.content).to eq(Notifications::DiscordNotifier::EXPIRED_MESSAGE)
      end

      it_behaves_like 'reval message basics'
    end
  end
end
