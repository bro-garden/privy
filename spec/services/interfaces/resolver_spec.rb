require 'rails_helper'

RSpec.describe Interfaces::Resolver do
  subject(:interface_resolver) { described_class.new(external_id:, source:) }

  describe '#call' do
    context 'when there is a valid iterface' do
      let(:external_id) { Faker::Internet.uuid }
      let(:source) { :discord_guild }

      it 'returns Interface' do
        expect(interface_resolver.call).to be_instance_of(Interface)
      end

      it 'sets an Interface to the interface attribute' do
        expect { interface_resolver.call }.to change(interface_resolver, :interface).from(nil).to(an_instance_of(Interface))
      end

      it 'sets Interface external_id with guild.id' do
        interface_resolver.call
        expect(interface_resolver.interface.external_id).to eq(external_id)
      end

      it 'sets Interface source with discord_guild' do
        interface_resolver.call
        expect(interface_resolver.interface.source.to_sym).to eq(source)
      end
    end

    context 'when there is an invalid interface' do
      before { create(:interface, :web) }

      let(:external_id) { nil }
      let(:source) { :web }

      it 'returns ActiveRecord::RecordInvalid' do
        expect { interface_resolver.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
