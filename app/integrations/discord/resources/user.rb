module Discord
  module Resources
    class User
      DISCORD_GLOBAL_NAME = 'Discord'.freeze

      attr_reader :id, :global_name, :username

      def initialize(id:, global_name:, username:)
        @id = id
        @global_name = global_name
        @username = username
      end

      def discord?
        global_name == DISCORD_GLOBAL_NAME
      end
    end
  end
end
