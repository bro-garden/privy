require 'rails_helper'

RSpec.describe Discord::Interactions::Resolvers::SayHi do
  subject(:say_hi) { described_class.new(request:, raw_body:, application:, guild:, user:) }

  include_context 'with mocked validation'
  include_context 'with resolver params'

  let(:params) { { 'data' => { 'name' => 'say_hi' } } }

  describe '#execute_action' do
    before do
      say_hi.execute_action
    end

    it 'adds a DiscordEngine::InteractionCallback instance to callback attribute' do
      expect(say_hi.callback).to be_an_instance_of(DiscordEngine::InteractionCallback)
    end

    it 'adds a callback of right type' do
      expect(say_hi.callback.type).to be(DiscordEngine::InteractionCallback::CHANNEL_MESSAGE_WITH_SOURCE_TYPE)
    end

    it 'populates content attribute' do
      expect(say_hi.content).to be_present
    end
  end

  describe '#call' do
    context 'when validations succeed' do
      before do
        say_hi.call
      end

      it 'adds a DiscordEngine::InteractionCallback instance to callback attribute' do
        expect(say_hi.callback).to be_an_instance_of(DiscordEngine::InteractionCallback)
      end

      it 'adds a callback of right type' do
        expect(say_hi.callback.type).to be(DiscordEngine::InteractionCallback::CHANNEL_MESSAGE_WITH_SOURCE_TYPE)
      end

      it 'populates content attribute' do
        expect(say_hi.content).to be_present
      end
    end

    context 'when validation fails' do
      let(:validation_result) { false }

      it 'raises an error' do
        expect { say_hi.call }.to raise_error(DiscordEngine::InvalidSignatureHeader)
      end
    end
  end
end
