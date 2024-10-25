module Discord
  class GuildRegistrar
    attr_reader :interface

    def initialize(guild)
      @guild = guild
    end

    def call
      register_guild
    end

    private

    attr_reader :guild

    def register_guild
      @interface = Interface.find_by(
        interface_type: :discord_guild,
        external_id: guild.id
      )

      return true if @interface.present?

      create_new_interface
    end

    def create_new_interface
      @interface = Interface.new(
        interface_type: :discord_guild,
        external_id: guild.id
      )
      raise InvalidGuild, interface unless @interface.valid?

      @interface.save!
    end
  end
end
