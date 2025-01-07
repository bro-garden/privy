module Discord
  module StatusNotices
    class Unauthorized
      include Rails.application.routes.url_helpers

      CONTENT = '⚠️ I couldn\'t share the message here. Please make sure' \
                     ' I have permission to send messages on this channel.' \
                     ' In the meantime, [click here](%<message_url>s) to see it.'.freeze

      attr_reader :message

      def initialize(message)
        @message = message
      end

      def build
        DiscordEngine::Message.new(
          content: format(CONTENT, message_url: message_url(message.id)),
          components: []
        )
      end
    end
  end
end
