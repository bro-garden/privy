module Discord
  module Interactions
    module Resolvers
      class SayHi < DiscordEngine::Resolvers::Resolver
        attr_reader :callback, :content

        COMMAND_NAME = 'say_hi'.freeze

        private

        def execute_action
          @callback = Resources::InteractionCallback.channel_message_with_source
          @content = "Hey everybody! @#{user.username} says hi!!"
        end
      end
    end
  end
end
