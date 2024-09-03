require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_numericality_of(:expiration_limit).only_integer.is_greater_than(0) }
  end

  describe 'associations' do
    it { should have_many(:message_visits).dependent(:destroy) }
  end

  describe '#expires_in_day?' do
    let(:message) { Message.new(expiration_type:) }

    context 'when is day' do
      let(:expiration_type) { 2 }

      it 'returns true' do
        expect(message.expires_in_day?).to be true
      end
    end

    context 'when is not day' do
      let(:expiration_type) { 3 }

      it 'returns true' do
        expect(message.expires_in_day?).to be false
      end
    end
  end

  describe '#expiration' do
    let(:message) { Message.new(expiration_limit: 10, expiration_type: 2) }
    let(:expiration) { message.expiration }

    it 'returns an struct' do
      expect(expiration).to be_a(Struct)
    end

    it 'returns the limit' do
      expect(expiration.limit).to eq(message.expiration_limit)
    end

    it 'returns the correct struct with limit and type' do
      expect(expiration.type.name).to eq('day')
    end
  end

  describe '#message_visits_count' do
    let(:message) { create(:message) }

    before do
      number_of_visits.times do
        create(:message_visit, message:)
      end
    end

    context 'when there are no visits' do
      let(:number_of_visits) { 0 }

      it 'returns nil' do
        expect(message.message_visits_count).to eq(nil)
      end
    end

    context 'when there are visits' do
      let(:number_of_visits) { 20 }

      it 'returns the number of visits' do
        expect(message.message_visits_count).to eq(number_of_visits)
      end
    end
  end
end
