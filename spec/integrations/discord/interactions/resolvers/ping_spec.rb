require 'rails_helper'

RSpec.describe Discord::Interactions::Resolvers::Ping do
  subject(:resolver) do
    described_class.new(request:, raw_body:, application:, guild:, user:)
  end

  include_context 'with dummy interaction request'
  include_context 'with raw body'
  include_context 'with resolver params'

  let(:interaction) { build(:interaction, type: 1) }

  describe '#name' do
    it "returns 'ping'" do
      expect(resolver.name).to eq('ping')
    end
  end

  describe '#call' do
    before do
      allow_any_instance_of(described_class).to receive(:valid_signature?).and_return(validation_return)
    end

    context 'when signature is valid' do
      let(:validation_return) { true }

      it 'returns a pong callback' do
        expect(resolver.call).to be_instance_of(Discord::Interactions::Callbacks::Pong)
      end

      context 'when global_name belongs to Discord' do
        it "change the 'callback' attribute" do
          expect { resolver.call }.to change(resolver, :callback).from(nil).to(Discord::Interactions::Callbacks::Pong)
        end
      end

      context 'when global_name is not Discord' do
        let(:global_name) { 'not-discord' }

        it 'raises Integrations::Discord::InvalidSignatureHeaderError' do
          expect { resolver.call }.to raise_error(Integrations::Discord::InvalidSignatureHeaderError)
        end
      end
    end

    context 'when signature is not valid' do
      let(:validation_return) { false }

      it 'raises Integrations::Discord::InvalidSignatureHeaderError' do
        expect { resolver.call }.to raise_error(Integrations::Discord::InvalidSignatureHeaderError)
      end
    end
  end
end
