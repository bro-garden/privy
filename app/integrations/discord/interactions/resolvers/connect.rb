module Discord
  module Interactions
    module Resolvers
      class Connect < Resolver
        attr_reader :callback, :content

        COMMAND_NAME = 'connect'.freeze

        private

        def execute_action
          registrate_guild

          @callback = Resources::InteractionCallback.channel_message_with_source
          @content = 'Hi @everyone, we have now connected privy'
        end

        def registrate_guild
          registrar = GuildRegistrar.new(guild)
          registrar.call
        rescue InvalidGuild
          raise ResolverFail, COMMAND_NAME
        end
      end
    end
  end
end
