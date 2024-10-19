require 'rails_helper'

RSpec.describe 'Discord integration interactions endpoint', type: :request do
  let(:user) { Integrations::Discord::Interactions::User.new(global_name:) }
  let(:request_params) { Integrations::Discord::Interactions::PingInteraction.new(user:).to_h }
  let(:global_name) { Discord::Interactions::Resolvers::Ping::EXPECTED_GLOBAL_NAME }

  before do
    allow_any_instance_of(Discord::Interactions::Resolvers::Ping).to receive(:valid_signature?).and_return(true)
  end

  describe 'POST /api/discord/interactions Ping' do
    context 'when the request is valid' do
      it 'returns a 200 status code' do
        post('/api/discord/interactions', params: request_params, headers:)
        expect(response).to have_http_status(200)
      end

      it 'returns pong type in response' do
        post('/api/discord/interactions', params: request_params, headers:)
        expect(JSON.parse(response.body)['type']).to eq(Discord::Interactions::Resolvers::Ping::PONG_RESPONSE_TYPE)
      end
    end

    context 'when signature is invalid' do
      before do
        allow_any_instance_of(Discord::Interactions::Resolvers::Ping).to receive(:valid_signature?).and_return(false)
      end

      it 'returns a 401 status code for invalid signature' do
        post('/api/discord/interactions', params: request_params, headers:)
        expect(response).to have_http_status(401)
      end

      it 'returns empty body for invalid request' do
        post('/api/discord/interactions', params: request_params, headers:)
        expect(response.body).to eq('')
      end
    end

    context 'when the request is invalid' do
      let(:global_name) { 'NotAValidName' }

      before do
        allow_any_instance_of(Discord::Interactions::Resolvers::Ping).to receive(:valid_signature?).and_return(true)
      end

      it 'returns a 401 status code for invalid signature' do
        post('/api/discord/interactions', params: request_params, headers:)
        expect(response).to have_http_status(401)
      end

      it 'returns empty body for invalid request' do
        post('/api/discord/interactions', params: request_params, headers:)
        expect(response.body).to eq('')
      end
    end
  end
end
