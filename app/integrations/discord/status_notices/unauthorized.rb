module Discord
  module StatusNotices
    class Unauthorized
      CONTENT = '⚠️ Could not create message: please make sure the bot has' \
                     ' permission to send messages on this channel'.freeze

      def build
        DiscordEngine::Message.new(
          content: CONTENT,
          components: []
        )
      end
    end
  end
end
