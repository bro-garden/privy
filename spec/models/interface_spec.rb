require 'rails_helper'

RSpec.describe Interface, source: :model do
  describe 'validations' do
    it { is_expected.to define_enum_for(:source).with_values(%i[discord_guild web api]) }
    it { is_expected.to validate_presence_of(:source) }

    context 'when source is not api or web' do
      let(:interface) { build(:interface, source: :discord_guild, external_id:) }

      context 'when external id is nil' do
        let(:external_id) { nil }

        it 'is invalid' do
          expect(interface).not_to be_valid
        end

        it 'adds a validation error to intreface' do
          interface.valid?
          expect(interface.errors[:external_id]).to include("can't be blank")
        end
      end

      context 'when external id is not nil' do
        let(:external_id) { 'an_external_id' }

        it 'is valid' do
          expect(interface).to be_valid
        end
      end
    end

    context 'when external_id is nil' do
      let(:interface) { build(:interface, source:, external_id: nil) }

      context 'when source is web' do
        let(:source) { :web }

        it 'is valid' do
          expect(build(:interface, source: :web, external_id: nil)).to be_valid
        end
      end

      context 'when source is api' do
        let(:source) { :api }

        it 'is valid' do
          expect(build(:interface, source: :web, external_id: nil)).to be_valid
        end
      end
    end

    context 'when creating an Interface of source for an already registered external_id' do
      let(:source) { :discord_guild }
      let(:external_id) { '12345' }
      let(:duplicate_interface) { build(:interface, source:, external_id:) }

      before do
        create(:interface, source:, external_id:)
      end

      it 'is invalid' do
        expect(duplicate_interface).not_to be_valid
      end

      it 'adds an error' do
        duplicate_interface.valid?
        expect(duplicate_interface.errors[:external_id]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe 'creatieg more than one singletones' do
    before { create(:interface, source:) }

    let(:interface) { build(:interface, source:) }

    context 'when creating a new web' do
      let(:source) { :web }

      it 'is not valid' do
        expect(interface.valid?).to be(false)
      end
    end

    context 'when creating a new api' do
      let(:source) { :api }

      it 'is not valid' do
        expect(interface.valid?).to be(false)
      end
    end
  end
end
