require 'rails_helper'

RSpec.describe Discord::Interactions::Resolvers::Resolver do
  include_context 'with right request headers'
  include_context 'with wrong request headers'
  include_context 'with dummy interaction request'
  include_context 'with raw body'
  include_context 'with resolver params'

  let(:headers) { right_headers }
  let(:interaction) { build(:interaction, type:) }

  describe '.find' do
    subject(:resolver) do
      described_class.find(
        interaction:,
        request:,
        raw_body:,
        application:,
        guild:,
        user:
      )
    end

    context 'when type is PING interaction request' do
      let(:type) { Discord::Resources::Interaction::PING_TYPE }

      it 'returns a Ping resolver instance' do
        expect(resolver).to be_instance_of(Discord::Interactions::Resolvers::Ping)
      end
    end

    context 'when type is not supported' do
      let(:type) { 20 }

      it 'raises an Integrations::Discord::ResolverNotFoundError' do
        expect { resolver }.to raise_error(Integrations::Discord::ResolverNotFoundError)
      end
    end
  end

  describe '#call' do
    subject(:resolver) { described_class.new(request:, raw_body:, application:, guild:, user:) }

    context 'when signature is valid' do
      let(:headers) { right_headers }

      it 'calls execute_action private method' do
        expect_any_instance_of(described_class).to receive(:execute_action)
        resolver.call
      end
    end

    context 'when signature is not valid' do
      let(:headers) { wrong_headers }

      it 'raises Integrations::Discord::InvalidSignatureHeaderError' do
        expect { resolver.call }.to raise_error(Integrations::Discord::InvalidSignatureHeaderError)
      end
    end
  end
end
