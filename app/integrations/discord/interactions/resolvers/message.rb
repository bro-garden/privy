module Discord
  module Interactions
    module Resolvers
      class Message < DiscordEngine::Resolvers::Resolver
        attr_reader :callback, :components, :content, :flags

        EPHEMERAL_MESSAGE_FLAG = 64

        def execute_action
          return reveal_message if reveal_privy?

          create_message
        end

        private

        def create_message
          create_interaction_response

          creator = Discord::PrivyCreator.new(resolver: self, channel_id:, message_params:, guild:)
          creator.call
        end

        def reveal_message
          # TODO: reveal_message privy message
        end

        def expiration_type
          option_value('expiration_type')
        end

        def expiration_limit
          option_value('expiration_limit')
        end

        def message_params
          {
            content: option_value('content'),
            expiration_limit: option_value('expiration_limit'),
            expiration_type: option_value('expiration_type')
          }
        end

        def create_interaction_response
          @callback = DiscordEngine::InteractionCallback.channel_message_with_source
          @flags = EPHEMERAL_MESSAGE_FLAG
          @content = 'Done!'
          @components = []
        end

        def reveal_privy?
          activated_component == Discord::ComponentBuilder::REVEAL_BUTTON_NAME
        end
      end
    end
  end
end
