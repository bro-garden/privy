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
          @content = 'Hey @everyone! **privy** is now connected and ready to use. ' \
                     'Type `/message` to send a secure message in any channel'
        end

        def registrate_guild
          registrar = Services::GuildRegistrar.new(guild)
          registrar.call
        rescue InvalidGuild
          raise ResolverFail, COMMAND_NAME
        end
      end
    end
  end
end
