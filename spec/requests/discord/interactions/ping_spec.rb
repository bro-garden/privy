require 'rails_helper'

RSpec.describe 'Discord integration interactions endpoint', type: :request do
  include_context 'with right request headers'
  include_context 'with wrong request headers'
  include_context 'with request body for right headers'

  let(:global_name) { Discord::Resources::User::DISCORD_GLOBAL_NAME }
  let(:endpoint) { '/api/integrations/discord/interactions' }
  let(:params) do
    {
      'app_permissions' => '562949953601536',
      'application_id' => '1296566140188754081',
      'authorizing_integration_owners' => {},
      'entitlements' => [],
      'id' => '1298349838022475838',
      'token' => 'aW50ZXJhY3Rpb246MTI5ODM0OTgzODAyMjQ3NTgzODo0QW1zSkpyNlNEMHJXd216aWpDRnhkNWZubnFWRVFCSmN6R280WURVcXFtRWJDd2ZSaW9Ebjk5T25obmtZanpLZDhVUzE4N2hsVzJ3Q284ZHNUTm1Ib2xHelZPYzBqWU93TjJmUVpoeVV3dGlDTWc4eUFvV2dIU1NJQmo0M2ZkSA',
      'type' => 1,
      'user' => { 'avatar' => 'c6a249645d46209f337279cd2ca998c7',
                  'avatar_decoration_data' => nil,
                  'bot' => true,
                  'clan' => nil,
                  'discriminator' => '0000',
                  'global_name' => global_name,
                  'id' => '643945264868098049',
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
        post(endpoint, params:, headers: right_headers)
        expect(response).to have_http_status(200)
      end

      it 'returns pong type in response' do
        post(endpoint, params:, headers: right_headers)
        expect(JSON.parse(response.body)['type']).to eq(Discord::Resources::Interaction::PONG_TYPE)
      end
    end

    context 'when the request is invalid' do
      let(:global_name) { 'NotAValidName' }

      it 'returns a 401 status code for invalid signature' do
        post(endpoint, params:, headers: right_headers)
        expect(response).to have_http_status(401)
      end

      it 'returns empty body for invalid request' do
        post(endpoint, params:, headers: right_headers)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'unauthorized request' })
      end
    end
  end
end
