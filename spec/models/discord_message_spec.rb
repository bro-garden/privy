require 'rails_helper'

RSpec.describe DiscordMessage, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:channel_id) }
  end

  describe 'index uniqueness' do
    let(:first_discord_message) { create(:discord_message) }
    let(:second_discord_message) { build(:discord_message, external_id:, channel_id:) }

    context 'when external_id and channel_id of a new discord_message are the same of an already extisting one' do
      let(:external_id) { first_discord_message.external_id }
      let(:channel_id) { first_discord_message.channel_id }

      it 'is invalid' do
        expect(second_discord_message).not_to be_valid
      end
    end

    context 'when external_id and channel_id of a new discord_message are different from an already extisting one' do
      let(:external_id) { Faker::Alphanumeric.alphanumeric(number: 10) }
      let(:channel_id) { Faker::Alphanumeric.alphanumeric(number: 10) }

      it 'is valid' do
        expect(second_discord_message).to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:message).optional }
  end
end
