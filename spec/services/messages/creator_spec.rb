require 'rails_helper'

RSpec.describe Messages::Creator do
  subject(:creator) { described_class.new(params:, source:, external_id:) }

  let!(:interface) { create(:interface, source:) }
  let(:params) do
    {
      content:,
      expiration_type:,
      expiration_limit: 1
    }
  end
  let(:content) { 'hello world!' }
  let(:external_id) { interface.external_id }

  describe '#call' do
    context 'when expiration is time_based' do
      let(:expiration_type) { :hour }

      context 'when interface is api' do
        let(:source) { :api }

        it_behaves_like 'successful time based message creation'
      end

      context 'when interface is web' do
        let(:source) { :web }

        it_behaves_like 'successful time based message creation'
      end

      context 'when interface is discord_guild' do
        let(:source) { :discord_guild }

        it_behaves_like 'successful time based message creation'
      end
    end

    context 'when expiration is visits_based' do
      let(:expiration_type) { :visit }

      context 'when interface is api' do
        let(:source) { :api }

        it_behaves_like 'successful visits based message creation'
      end

      context 'when interface is web' do
        let(:source) { :web }

        it_behaves_like 'successful visits based message creation'
      end

      context 'when interface is discord_guild' do
        let(:source) { :discord_guild }

        it_behaves_like 'successful visits based message creation'
      end
    end

    context 'when there is an error with message' do
      let(:source) { :api }
      let(:expiration_type) { :hour }
      let(:content) { '' }
      let(:message_expiration_job) { instance_double(Messages::ExpireJob) }

      before do
        allow(Messages::ExpireJob).to receive(:set).and_return(message_expiration_job)
      end

      it 'raieses an error' do
        expect { creator.call }.to raise_error(Messages::CreationFailed)
      end

      it 'does not enqueue a Messages::ExpireJob' do
        expect(Messages::ExpireJob).not_to have_received(:set)
      end
    end
  end
end
