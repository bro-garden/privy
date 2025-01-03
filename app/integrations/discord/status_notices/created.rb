module Discord
  module StatusNotices
    class Created
      CONTENT = '✅ Message created!'.freeze

      def build
        DiscordEngine::Message.new(
          content: CONTENT,
          components: []
        )
      end
    end
  end
end
