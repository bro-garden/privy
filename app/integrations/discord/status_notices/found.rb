module Discord
  module StatusNotices
    class Found
      attr_reader :message_content

      def initialize(message_content)
        @message_content = message_content
      end

      def build
        DiscordEngine::Message.new(
          content: message_content,
          components: []
        )
      end
    end
  end
end
