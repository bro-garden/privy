module Discord
  module Services
    class GuildRegistrar
      attr_reader :interface

      def initialize(guild)
        @guild = guild
      end

      def call
        @interface = Interface.find_or_create_by!(
          interface_type: :discord_guild,
          external_id: guild.id
        )
      rescue ActiveRecord::RecordInvalid => e
        raise InvalidGuild, e.record
      end

      private

      attr_reader :guild
    end
  end
end
