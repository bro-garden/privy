module Discord
  module StatusNotices
    class Expired
      CONTENT = '⚠️ This message has expired'.freeze

      def build
        DiscordEngine::Message.new(
          content: CONTENT,
          components: []
        )
      end
    end
  end
end
