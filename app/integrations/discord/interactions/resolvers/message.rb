module Discord
  module Interactions
    module Resolvers
      class Message < DiscordEngine::Resolvers::Resolver
        attr_reader :callback, :components, :content, :flags

        MESSAGE_CREATED_CONTENT = 'Hey @everyone! here is a new **privy** message'.freeze
        REVEAL_BUTTON_LABEL = 'Reveal'.freeze
        REVEAL_MESSAGE_RESOLVER = 'Discord::Interactions::Resolvers::RevealMessage'.freeze

        def execute_action
          message = create_message
          message_component = create_message_component(message)
          send_message(message_component)

          @callback = DiscordEngine::InteractionCallback.channel_message_with_source
          @content = 'Done, message created'
          @flags = DiscordEngine::Message::EPHEMERAL_FLAG
          @components = []
        end

        private

        def create_message
          message_creator = Messages::Creator.new(
            params: message_params,
            source: :discord_guild,
            external_id: guild.id
          )
          message_creator.call
          message_creator.message
        end

        def create_message_component(message)
          reveal_button = DiscordEngine::MessageComponents::Button.new(
            label: REVEAL_BUTTON_LABEL,
            style: :success,
            resolver_name: REVEAL_MESSAGE_RESOLVER,
            data: { message_id: message.id }
          )

          action_row = DiscordEngine::MessageComponents::ActionRow.new
          action_row.add(reveal_button)
          action_row
        end

        def send_message(message_component)
          DiscordEngine::Message.new(
            content: MESSAGE_CREATED_CONTENT,
            components: [message_component]
          ).create(channel_id:)
        end

        def message_params
          {
            content: option_value('content'),
            expiration_limit: option_value('expiration_limit'),
            expiration_type: option_value('expiration_type')
          }
        end
      end
    end
  end
end