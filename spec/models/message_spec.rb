require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_numericality_of(:expiration_limit).only_integer.is_greater_than(0) }
  end

  describe '#expires_in_one_day?' do
    let(:message) { Message.new(expiration_type:) }

    context 'when is one_day' do
      let(:expiration_type) { 2 }

      it 'returns true' do
        expect(message.expires_in_one_day?).to be true
      end
    end

    context 'when is not one_day' do
      let(:expiration_type) { 3 }

      it 'returns true' do
        expect(message.expires_in_one_day?).to be false
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
      expect(expiration.type.name).to eq('one_day')
    end
  end
end
