module Discord
  module Interactions
    module Resolvers
      class Message < DiscordEngine::Resolvers::Resolver
        attr_reader :callback, :notice, :flags

        def execute_action
          ActiveRecord::Base.transaction do
            message = create_message
            create_available_notice(message)

            @notice = StatusNotices::Created.new.build
          end
        rescue Discordrb::Errors::NoPermission => _e
          @notice = StatusNotices::Unauthorized.new.build
        rescue Messages::CreationFailed => e
          @notice = StatusNotices::CreationFailed.new(e.message).build
        ensure
          @callback = DiscordEngine::InteractionCallback.channel_message_with_source
          @flags = DiscordEngine::Message::EPHEMERAL_FLAG
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

        def create_available_notice(message)
          available_notice = StatusNotices::Available.new(message).build
          available_notice.create(
            channel_id: context.channel_id,
            reference_id: message.id
          )
        end
      end
    end
  end
end
