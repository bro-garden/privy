require 'rails_helper'

RSpec.describe Discord::Interactions::Resolvers::Connect do
  subject(:connect) { described_class.new(context:) }

  let(:context) { DiscordEngine::Resolvers::Context.new(params:) }
  let(:params) { load_json('interactions/connect.json') }

  describe '#execute_action' do
    before do
      connect.execute_action
    end

    it 'adds a DiscordEngine::InteractionCallback instance to callback attribute' do
      expect(connect.callback).to be_an_instance_of(DiscordEngine::InteractionCallback)
    end

    it 'adds a callback of right type' do
      expect(connect.callback.type).to be(DiscordEngine::InteractionCallback::CHANNEL_MESSAGE_WITH_SOURCE_TYPE)
    end

    it 'populates content attribute' do
      expect(connect.content).to be_present
    end
  end
end
