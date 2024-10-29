module Discord
  module Interactions
    module Resolvers
      class Connect < DiscordEngine::Resolvers::Resolver
        attr_reader :callback, :content

        def execute_action
          registrate_guild

          @callback = DiscordEngine::InteractionCallback.channel_message_with_source
          @content = 'Hey @everyone! **privy** is now connected and ready to use. ' \
                     'Type `/message` to send a secure message in any channel'
        end

        private

        def registrate_guild
          registrar = Interfaces::Resolver.new(source: :discord_guild, external_id: guild.id)
          registrar.call
        rescue ActiveRecord::RecordInvalid
          raise DiscordEngine::ResolverFail, COMMAND_NAME
        end
      end
    end
  end
end
