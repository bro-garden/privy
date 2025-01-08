module Discord
  module Interactions
    module Resolvers
      class RevealMessage < DiscordEngine::Resolvers::Resolver
        attr_reader :callback, :notice

        def execute_action
          message_text = read_message_text!
          @notice = Discord::StatusNotices::Found.new(message_text).build
        rescue ActiveRecord::RecordNotFound => _e
          @notice = Discord::StatusNotices::NotFound.new.build
        rescue Messages::ExpiredError => _e
          @notice = Discord::StatusNotices::Expired.new.build
        ensure
          @callback = DiscordEngine::InteractionCallback.update_message
        end

        private

        def read_message_text!
          message = ::Message.find_by!(uuid: message_uuid)
          reader = Messages::Reader.new(message)
          reader.read_message.to_plain_text
        end

        def message_uuid
          @message_uuid ||= context.metadata.dig(:data, 'message_uuid')
        end
      end
    end
  end
end
