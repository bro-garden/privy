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
      read['data']['custom_id'] = "{\"resolver_name\":\"reveal_message\",\"data\":{\"message_uuid\":\"#{uuid}\"}}"

      read
    end

    context 'when message relevation succeeds' do
      let(:message) { create(:message) }
      let(:uuid) { message.uuid }
      let(:dicord_message_visibility_job) { class_spy(Discord::Jobs::Messages::HideJob) }

      before do
        allow(Discord::Jobs::Messages::HideJob).to receive(:set).and_return(dicord_message_visibility_job)
        message_resolver.execute_action
      end

      it 'sets success content' do
        expect(message_resolver.notice.content).to eq(message.content.to_plain_text)
      end

      it_behaves_like 'reval message basics'
    end

    context 'when message does not exist' do
      let(:uuid) { '0' }

      before do
        message_resolver.execute_action
      end

      it 'sets error content' do
        expect(message_resolver.notice.content).to eq(Discord::StatusNotices::NotFound::CONTENT)
      end

      it_behaves_like 'reval message basics'
    end

    context 'when message has expired' do
      let(:message) { create(:message, expiration_limit: 1, expiration_type: 'visit') }
      let(:uuid) { message.uuid }

      before do
        create_list(:message_visit, 1, message:)
        message_resolver.execute_action
      end

      it 'sets error content' do
        expect(message_resolver.notice.content).to eq(Discord::StatusNotices::Expired::CONTENT)
      end

      it_behaves_like 'reval message basics'
    end
  end
end
