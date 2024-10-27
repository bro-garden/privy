require 'rails_helper'

RSpec.describe Interface, interface_type: :model do
  describe 'validations' do
    it { is_expected.to define_enum_for(:interface_type).with_values(%i[discord_guild web api]) }
    it { is_expected.to validate_presence_of(:interface_type) }

    context 'when interface_type is not api or web' do
      let(:interface) { build(:interface, interface_type: :discord_guild, external_id:) }

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
      let(:interface) { build(:interface, interface_type:, external_id: nil) }

      context 'when interface_type is web' do
        let(:interface_type) { :web }

        it 'is valid' do
          expect(build(:interface, interface_type: :web, external_id: nil)).to be_valid
        end
      end

      context 'when interface_type is api' do
        let(:interface_type) { :api }

        it 'is valid' do
          expect(build(:interface, interface_type: :web, external_id: nil)).to be_valid
        end
      end
    end

    context 'when creating an Interface of interface_type for an already registered external_id' do
      let(:interface_type) { :discord_guild }
      let(:external_id) { '12345' }
      let(:duplicate_interface) { build(:interface, interface_type:, external_id:) }

      before do
        create(:interface, interface_type:, external_id:)
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

  describe 'web Interface' do
    let!(:web_interface) { create(:interface, interface_type: :web) }

    context 'when creating a new web interface' do
      let(:interface) { create(:interface, interface_type: :web) }

      it 'returns existing web interface' do
        expect(interface).to eq(web_interface)
      end
    end

    context 'when creating any amount of web interfaces' do
      before do
        create_list(:interface, [2, 5, 10].sample, interface_type: :web)
      end

      it 'keeps only one web interface' do
        expect(described_class.web.count).to eq(1)
      end
    end
  end

  describe 'api Interface' do
    let!(:api_interface) { create(:interface, interface_type: :api) }

    context 'when creating a new api interface' do
      let(:interface) { create(:interface, interface_type: :api) }

      it 'returns existing api interface' do
        expect(interface).to eq(api_interface)
      end
    end

    context 'when creating any amount of api interfaces' do
      before do
        create_list(:interface, [2, 5, 10].sample, interface_type: :api)
      end

      it 'keeps only one api interface' do
        expect(described_class.api.count).to eq(1)
      end
    end
  end
end
