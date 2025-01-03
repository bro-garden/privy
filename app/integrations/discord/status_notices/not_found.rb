module Discord
  module StatusNotices
    class NotFound
      CONTENT = '⚠️ This message was not found'.freeze

      def build
        DiscordEngine::Message.new(
          content: CONTENT,
          components: []
        )
      end
    end
  end
end
