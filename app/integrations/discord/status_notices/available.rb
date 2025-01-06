module Discord
  module StatusNotices
    class Available
      attr_reader :message

      CONTENT = 'Hey @everyone! here is a new **privy** message'.freeze
      REVEAL_BUTTON_LABEL = 'Reveal'.freeze

      def initialize(message)
        @message = message
      end

      def build
        DiscordEngine::Message.new(
          content: CONTENT,
          components: build_reveal_button
        )
      end

      private

      def build_reveal_button
        reveal_button = DiscordEngine::MessageComponents::Button.new(
          label: REVEAL_BUTTON_LABEL,
          style: :success,
          resolver_name:,
          data: { message_id: message.id }
        )

        action_row = DiscordEngine::MessageComponents::ActionRow.new
        action_row.add(reveal_button)
        [action_row]
      end

      def resolver_name
        Interactions::Resolvers::RevealMessage.to_s.demodulize.underscore
      end
    end
  end
end
