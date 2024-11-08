RSpec.shared_context 'with resolver params' do
  let(:request) { instance_double(Request, params:, headers:) }
  let(:raw_body) { 'Some raw body content' }
  let(:application) { build(:discord_application) }
  let(:guild) { build(:discord_guild) }
  let(:user) { build(:discord_user) }
  let(:params) { { 'data' => { 'name' => 'say_hi' } } }
  let(:headers) { { 'x-signature-ed25519' => signature_value, 'x-signature-timestamp' => timestamp_value } }
  let(:signature_value) { 'signature_value' }
  let(:timestamp_value) { 'timestamp_value' }
end
