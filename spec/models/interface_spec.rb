require 'rails_helper'

RSpec.describe Interface, interface_type: :model do
  describe 'validations' do
    it { is_expected.to define_enum_for(:interface_type).with_values(%i[discord_guild web api]) }
    it { is_expected.to validate_presence_of(:interface_type) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe '.web' do
    context 'when a web interface does not exist' do
      it 'creates a new web interface' do
        expect { described_class.web }.to change { described_class.where(interface_type: :web).count }.from(0).to(1)
      end
    end

    context 'when a web interface already exists' do
      let!(:interface) { create(:interface, interface_type: :web) }

      it 'returns the existing web interface' do
        expect(described_class.web).to eq(interface)
      end
    end
  end

  describe '.api' do
    context 'when an api interface does not exist' do
      it 'creates a new api interface' do
        expect { described_class.api }.to change { described_class.where(interface_type: :api).count }.from(0).to(1)
      end
    end

    context 'when an api interface already exists' do
      let!(:interface) { create(:interface, interface_type: :api) }

      it 'returns the existing api interface' do
        expect(described_class.api).to eq(interface)
      end
    end
  end
end
