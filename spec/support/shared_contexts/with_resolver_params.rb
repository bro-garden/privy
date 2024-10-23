RSpec.shared_context 'with resolver params' do
  let(:application) { build(:application) }
  let(:guild) { build(:guild) }
  let(:user) { build(:user, global_name:) }

  let(:global_name) { Discord::Resources::User::DISCORD_GLOBAL_NAME }
  let(:interaction) { build(:interaction) }
  let(:headers) { {} }
  let(:params) { {} }
end
