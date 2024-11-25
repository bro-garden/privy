module Discord
  module Interactions
    module Resolvers
      class RevealMessage < DiscordEngine::Resolvers::Resolver
        attr_reader :callback, :content, :components

        def execute_action
          message_text = read_message_text!
          @content = message_text
        rescue ActiveRecord::RecordNotFound => _e
          @content = '⚠️ Could not find the message'
        rescue Messages::ExpirationTypeError => _e
          @content = '⚠️ This message has expired'
        ensure
          @callback = DiscordEngine::InteractionCallback.update_message
          @components = []
        end

        private

        def read_message_text!
          message = ::Message.find(message_id)

          reader = Messages::Reader.new(message)
          reader.read_message.to_plain_text
        end

        def message_id
          @message_id ||= context.metadata.dig(:data, 'message_id')
        end
      end
    end
  end
end
