module Discord
  module Interactions
    module Resolvers
      class Message < DiscordEngine::Resolvers::Resolver
        attr_reader :callback, :components, :content, :flags

        def execute_action
          ActiveRecord::Base.transaction do
            message = create_message
            Notifications::DiscordNotifier.new(message).notify_message_creation!(
              RevealMessage.to_s.demodulize.underscore,
              context.channel_id
            )

            @content = '✅ Message created!'
          end
        rescue Discordrb::Errors::NoPermission => _e
          @content = '⚠️ Could not create message: please make sure the bot has' \
                     ' permission to send messages on this channel'
        rescue Messages::CreationFailed => e
          @content = "⚠️ Could not create message: #{e.message}"
        ensure
          @callback = DiscordEngine::InteractionCallback.channel_message_with_source
          @flags = DiscordEngine::Message::EPHEMERAL_FLAG
          @components = []
        end

        private

        def create_message
          message_creator = Messages::Creator.new(
            params: message_params,
            source: :discord_guild,
            external_id: context.guild.id
          )
          message_creator.call
          message_creator.message
        end

        def message_params
          {
            content: context.option_value('content'),
            expiration_limit: context.option_value('expiration_limit'),
            expiration_type: context.option_value('expiration_type')
          }
        end
      end
    end
  end
end
