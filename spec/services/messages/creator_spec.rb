require 'rails_helper'

RSpec.describe Messages::Creator do
  subject(:creator) { described_class.new(params:, source:, external_id:) }

  let(:interface) { create(:interface, source:) }
  let(:source) { :api }
  let(:external_id) { interface.external_id }
  let(:params) do
    {
      content:,
      expiration_type: :hour,
      expiration_limit: 1
    }
  end

  describe '#call' do
    let(:content) { 'hello world!' }

    context 'when interface is api' do
      let(:source) { :api }

      it 'returns true' do
        expect(creator.call).to be(true)
      end

      it 'creates a Message instance in message attribute' do
        creator.call
        expect(creator.message).to be_instance_of(Message)
      end
    end

    context 'when interface is web' do
      let(:source) { :web }

      it 'returns true' do
        expect(creator.call).to be(true)
      end

      it 'creates a Message instance in message attribute' do
        creator.call
        expect(creator.message).to be_instance_of(Message)
      end
    end

    context 'when interface is discord_guild' do
      let(:source) { :discord_guild }

      it 'returns true' do
        expect(creator.call).to be(true)
      end

      it 'creates a Message instance in message attribute' do
        creator.call
        expect(creator.message).to be_instance_of(Message)
      end
    end

    context 'when there is an error with message' do
      let(:content) { '' }

      it 'raieses an error' do
        expect { creator.call }.to raise_error(Messages::CreationFailed)
      end
    end
  end
end
