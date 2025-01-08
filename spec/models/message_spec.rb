require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    subject { build(:message) }

    it { is_expected.to validate_numericality_of(:expiration_limit).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:expiration_type) }
    it { is_expected.to validate_presence_of(:content) }

    describe '`expired` validation' do
      it 'is invalid when expired is nil' do
        message = build(:message, expired: nil)
        expect(message).not_to be_valid
      end

      it 'returns the correct error message' do
        message = build(:message, expired: nil)
        message.valid?
        expect(message.errors[:expired]).to include('is not included in the list')
      end

      it 'is valid when expired is true' do
        message = build(:message, expired: true)
        expect(message).to be_valid
      end

      it 'is valid when expired is false' do
        message = build(:message, expired: false)
        expect(message).to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:message_visits).dependent(:destroy) }
    it { is_expected.to belong_to(:interface) }
  end

  describe '#expiration' do
    let(:message) { described_class.new(expiration_limit: 10, expiration_type: 'day') }
    let(:expiration) { message.expiration }

    it 'returns an struct' do
      expect(expiration).to be_a(MessageExpiration)
    end

    it 'returns the limit' do
      expect(expiration.limit).to eq(message.expiration_limit)
    end

    it 'returns the correct struct with limit and type' do
      expect(expiration.type).to eq('day')
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
        expect(message.message_visits_count).to be_nil
      end
    end

    context 'when there are visits' do
      let(:number_of_visits) { 20 }

      it 'returns the number of visits' do
        expect(message.message_visits_count).to eq(number_of_visits)
      end
    end
  end

  describe '#available?' do
    let(:interface) { create(:interface) }

    context 'with time-based expiration' do
      context 'when message has not expired' do
        let(:message) { create(:message, interface: interface, expiration_limit: 1, expiration_type: :day) }

        it 'returns true' do
          expect(message).to be_available
        end

        context 'when checking just before expiration' do
          it 'returns true' do
            Timecop.freeze(message.created_at + 23.hours + 59.minutes) do
              expect(message).to be_available
            end
          end
        end
      end

      context 'when message has expired' do
        let(:message) { create(:message, interface: interface, expiration_limit: 1, expiration_type: :hour) }

        it 'returns false' do
          Timecop.freeze(message.created_at + 2.hours) do
            expect(message).not_to be_available
          end
        end
      end
    end

    context 'with visit-based expiration' do
      context 'when message has not reached visit limit' do
        let(:message) { create(:message, interface: interface, expiration_limit: 2, expiration_type: :visits) }

        it 'returns true with no visits' do
          expect(message).to be_available
        end

        context 'with one visit' do
          before do
            create(:message_visit, message: message)
          end

          it 'returns true with visits under limit' do
            expect(message.reload).to be_available
          end
        end
      end

      context 'when message has reached visit limit' do
        let(:message) { create(:message, interface: interface, expiration_limit: 1, expiration_type: :visit) }

        before do
          create(:message_visit, message: message)
        end

        it 'returns false' do
          expect(message.reload).not_to be_available
        end
      end
    end

    context 'with invalid expiration type' do
      let(:message) { create(:message, interface: interface, expiration_limit: 1, expiration_type: :day) }

      before do
        expiration_double = instance_double(MessageExpiration, time_based?: false, visits_based?: false)
        allow(MessageExpiration).to receive(:new).and_return(expiration_double)
      end

      it 'raises an error for invalid expiration type' do
        expect { message.available? }.to raise_error(Messages::ExpirationTypeError)
      end
    end
  end
end
