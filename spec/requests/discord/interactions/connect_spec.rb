require 'rails_helper'

RSpec.describe 'Discord integration interactions endpoint', type: :request do
  include_context 'with mocked validation'

  let(:validation_result) { true }
  let(:guild_id) { Faker::Internet.uuid }
  let(:endpoint) { '/api/integrations/discord/interactions' }
  let(:params) do
    {
      'app_permissions' => Faker::Internet.uuid,
      'application_id' => Faker::Internet.uuid,
      'authorizing_integration_owners' => {
        '0' => Faker::Internet.uuid
      },
      'channel' => {
        'flags' => 0,
        'guild_id' => Faker::Internet.uuid,
        'id' => Faker::Internet.uuid,
        'last_message_id' => Faker::Internet.uuid,
        'name' => 'bienvenida-y-reglas',
        'nsfw' => false,
        'parent_id' => Faker::Internet.uuid,
        'permissions' => Faker::Internet.uuid,
        'position' => 1,
        'rate_limit_per_user' => 0,
        'topic' => nil,
        'type' => 0
      },
      'channel_id' => Faker::Internet.uuid,
      'context' => 0,
      'data' => {
        'id' => Faker::Internet.uuid,
        'name' => 'connect',
        'type' => 1
      },
      'entitlement_sku_ids' => [],
      'entitlements' => [],
      'guild' => {
        'features' => [],
        'id' => Faker::Internet.uuid,
        'locale' => 'en-US'
      },
      'guild_id' => guild_id,
      'guild_locale' => 'en-US',
      'id' => Faker::Internet.uuid,
      'locale' => 'es-ES',
      'member' => {
        'avatar' => nil,
        'banner' => nil,
        'communication_disabled_until' => nil,
        'deaf' => false,
        'flags' => 0,
        'joined_at' => Time.current.iso8601,
        'mute' => false,
        'nick' => nil,
        'pending' => false,
        'permissions' => Faker::Internet.uuid,
        'premium_since' => nil,
        'roles' => [],
        'unusual_dm_activity_until' => nil,
        'user' => {
          'avatar' => nil,
          'avatar_decoration_data' => nil,
          'clan' => nil,
          'discriminator' => '0',
          'global_name' => 'immprada',
          'id' => Faker::Internet.uuid,
          'public_flags' => 0,
          'username' => 'immprada'
        }
      },
      'token' => 'token',
      'type' => 2,
      'version' => 1
    }
  end

  it_behaves_like 'unauthorizable request'

  describe 'POST /api/integrations/discord/interactions Connectå' do
    context 'when the request is valid' do
      it 'returns a 200 status code' do
        post(endpoint, params:)
        expect(response).to have_http_status(200)
      end

      it 'returns pong type in response' do
        post(endpoint, params:)
        expect(JSON.parse(response.body)['type']).to eq(
          Discord::Resources::InteractionCallback::CHANNEL_MESSAGE_WITH_SOURCE_TYPE
        )
      end

      it 'returns content into response body' do
        post(endpoint, params:)
        expect(JSON.parse(response.body)['data']['content']).to be_present
      end
    end

    context 'when the request is invalid' do
      let(:guild_id) { '' }

      it 'returns a 400 status code' do
        post(endpoint, params:)
        expect(response).to have_http_status(400)
      end
    end
  end
end
