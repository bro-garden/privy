module Discord
  module StatusNotices
    class CreationFailed
      CONTENT = '⚠️ Could not create message: %<error_message>s'.freeze

      attr_reader :error_message

      def initialize(error_message)
        @error_message = error_message
      end

      def build
        DiscordEngine::Message.new(
          content: format(CONTENT, error_message:),
          components: []
        )
      end
    end
  end
end
