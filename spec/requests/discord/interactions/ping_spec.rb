require 'rails_helper'

RSpec.describe 'Discord integration interactions endpoint', type: :request do
  include_context 'with mocked validation'

  let(:validation_result) { true }
  let(:global_name) { Discord::Resources::User::DISCORD_GLOBAL_NAME }
  let(:endpoint) { '/api/integrations/discord/interactions' }
  let(:params) do
    {
      'app_permissions' => Faker::Internet.uuid,
      'application_id' => Faker::Internet.uuid,
      'authorizing_integration_owners' => {},
      'entitlements' => [],
      'id' => Faker::Internet.uuid,
      'token' => 'token',
      'type' => 1,
      'user' => { 'avatar' => Faker::Internet.uuid,
                  'avatar_decoration_data' => nil,
                  'bot' => true,
                  'clan' => nil,
                  'discriminator' => '0000',
                  'global_name' => global_name,
                  'id' => Faker::Internet.uuid,
                  'public_flags' => 1,
                  'system' => true,
                  'username' => 'discord' },
      'version' => 1
    }
  end

  it_behaves_like 'unauthorizable request'

  describe 'POST /api/integrations/discord/interactions Ping' do
    context 'when the request is valid' do
      it 'returns a 200 status code' do
        post(endpoint, params:)
        expect(response).to have_http_status(200)
      end

      it 'returns pong type in response' do
        post(endpoint, params:)
        expect(JSON.parse(response.body)['type']).to eq(Discord::Resources::InteractionCallback::PONG_TYPE)
      end
    end

    context 'when the request is invalid' do
      let(:global_name) { 'NotAValidName' }

      it 'returns a 401 status code for invalid signature' do
        post(endpoint, params:)
        expect(response).to have_http_status(401)
      end

      it 'returns empty body for invalid request' do
        post(endpoint, params:)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'unauthorized request' })
      end
    end
  end
end
