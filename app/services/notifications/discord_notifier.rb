module Notifications
  class DiscordNotifier
    attr_reader :discord_message

    EXPIRED_MESSAGE = '⚠️ This message has expired'.freeze
    MESSAGE_CREATED_CONTENT = 'Hey @everyone! here is a new **privy** message'.freeze
    REVEAL_BUTTON_LABEL = 'Reveal'.freeze

    def initialize(message)
      @message = message
    end

    def notify_message_expiration!
      @discord_message = message.external_message
      send_expired_message_notification!(
        @discord_message.channel_id,
        @discord_message.external_id
      )
    end

    def notify_message_hidden!(resolver_name)
      return reset_visibility!(resolver_name) if reset_visibility?

      Messages::Expirer.new(message).call
    end

    private

    attr_reader :message

    def send_expired_message_notification!(channel_id, message_id)
      DiscordEngine::Message.new(
        content: EXPIRED_MESSAGE,
        components: []
      ).update(channel_id:, message_id:)
    end

    def reset_visibility!(resolver_name)
      components = build_non_expired_message_components(resolver_name)
      discord_message = message.external_message
      channel_id = discord_message.channel_id
      message_id = discord_message.external_id

      DiscordEngine::Message.new(
        content: Discord::Interactions::Resolvers::Message::MESSAGE_CREATED_CONTENT,
        components:
      ).update(channel_id:, message_id:)
    end

    def visit_based_visits_unreached?
      message.message_visits_count.to_i < message.expiration.limit
    end

    def reset_visibility?
      message.expiration.time_based? || visit_based_visits_unreached?
    end

    def build_non_expired_message_components(resolver_name)
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
  end
end
