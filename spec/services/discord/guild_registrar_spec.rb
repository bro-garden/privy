require 'rails_helper'

RSpec.describe Discord::GuildRegistrar do
  subject(:registrar) { described_class.new(guild) }

  describe '#call' do
    context 'when there is a valid guild' do
      let(:guild) { create(:guild) }

      it 'returns true' do
        expect(registrar.call).to be(true)
      end

      it 'sets an Interface to the interface attribute' do
        expect { registrar.call }.to change(registrar, :interface).from(nil).to(an_instance_of(Interface))
      end

      it 'sets Interface external_id with guild.id' do
        registrar.call
        expect(registrar.interface.external_id).to eq(guild.id)
      end

      it 'sets Interface interface_type with discord_guild' do
        registrar.call
        expect(registrar.interface.interface_type).to eq('discord_guild')
      end
    end

    context 'when there is an invalid guild' do
      let(:guild) { create(:guild, id: nil) }

      it 'returns Discord::InvalidGuild' do
        expect { registrar.call }.to raise_error(Discord::InvalidGuild)
      end
    end
  end
end
