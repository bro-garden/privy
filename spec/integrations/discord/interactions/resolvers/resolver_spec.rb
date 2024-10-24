require 'rails_helper'

RSpec.describe Discord::Interactions::Resolvers::Resolver do
  include_context 'with dummy interaction request'
  include_context 'with resolver params'
  include_context 'with mocked validation'

  let(:interaction) { build(:interaction, type:) }
  let(:raw_body) { {} }

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

    context 'when type is APPLICATION_COMMAND_TYPE' do
      let(:type) { Discord::Resources::Interaction::APPLICATION_COMMAND_TYPE }
      let(:params) do
        {
          'data' => {
            'id' => Faker::Internet.uuid,
            'name' => command_name,
            'type' => 1
          }
        }
      end

      context 'when command is /say_hi' do
        let(:command_name) { 'say_hi' }

        it 'returns a SayHi resolver instance' do
          expect(resolver).to be_instance_of(Discord::Interactions::Resolvers::SayHi)
        end
      end

      context 'when command is not supported' do
        let(:command_name) { 'command_not_supported' }

        it 'raises an Discord::CommandNotSupported' do
          expect { resolver }.to raise_error(Discord::CommandNotSupported)
        end
      end

      context 'when command is blank' do
        let(:params) { [{}, { 'data' => {} }, { 'data' => { 'name' => '' } }].sample }

        it 'raises an Discord::CommandBlank' do
          expect { resolver }.to raise_error(Discord::CommandBlank)
        end
      end
    end

    context 'when type is not supported' do
      let(:type) { 20 }

      it 'raises an Discord::ResolverNotFound' do
        expect { resolver }.to raise_error(Discord::ResolverNotFound)
      end
    end
  end

  describe '#call' do
    subject(:resolver) { described_class.new(request:, raw_body:, application:, guild:, user:) }

    context 'when signature is valid' do
      let(:validation_result) { true }

      it 'calls execute_action private method' do
        expect_any_instance_of(described_class).to receive(:execute_action)
        resolver.call
      end
    end

    context 'when signature is not valid' do
      let(:validation_result) { false }

      it 'raises Discord::InvalidSignatureHeader' do
        expect { resolver.call }.to raise_error(Discord::InvalidSignatureHeader)
      end
    end
  end
end
