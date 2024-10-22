RSpec.shared_context 'with request body for right headers' do
  let(:body_struct) { Struct.new(:read) }

  let(:payload) do
    {
      app_permissions: '562949953601536',
      application_id: '1296566140188754081',
      authorizing_integration_owners: {},
      entitlements: [],
      id: '1298334875052408953',
      token: 'aW50ZXJhY3Rpb246MTI5ODMzNDg3NTA1MjQwODk1MzpYZUdqTnBnWjJrc015c2JXenZ4MXhFQ3VDVTl2cW9yNmFmOVdQOXJkcjVsbDNXdDljdjlPelhhcURCdGlEa1pPeEg3dEhoTm1BejhHTnNjTDA4Y0tGMndNN1VvYmpEZ1FGZFNMWjVYbFBUaTJvTEF1WmR3Ylp6VG9LWVRvWjhqdg',
      type: 1,
      user: {
        avatar: 'c6a249645d46209f337279cd2ca998c7',
        avatar_decoration_data: nil,
        bot: true,
        clan: nil,
        discriminator: '0000',
        global_name: 'Discord',
        id: '643945264868098049',
        public_flags: 1,
        system: true,
        username: 'discord'
      },
      version: 1
    }
  end

  before do
    allow_any_instance_of(Grape::Request).to receive(:body).and_return(body_struct.new(payload.to_json))
  end
end
