require 'rails_helper'

RSpec.describe DiscordMessage, type: :model do
  describe 'validations' do
    before { create(:discord_message) }

    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:channel_id) }
    it { is_expected.to validate_uniqueness_of(:external_id).scoped_to(:channel_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:message) }
  end
end
