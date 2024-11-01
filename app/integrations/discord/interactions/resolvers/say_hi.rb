module Discord
  module Interactions
    module Resolvers
      class SayHi < DiscordEngine::Resolvers::Resolver
        attr_reader :callback, :content

        def execute_action
          @callback = DiscordEngine::InteractionCallback.channel_message_with_source
          @content = "Hey everybody! @#{user.username} says hi!!"
        end

        private

        def requires_connection?
          true
        end
      end
    end
  end
end
