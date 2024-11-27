module Notifications
  class DiscordNotifier
    attr_reader :discord_message

    EXPIRED_MESSAGE = '⚠️ This message has expired'.freeze
    MESSAGE_CREATED_CONTENT = 'Hey @everyone! here is a new **privy** message'.freeze
    REVEAL_BUTTON_LABEL = 'Reveal'.freeze

    def initialize(message)
      @message = message
    end

    def notify_message_state!(resolver_name)
      return send_message_existence_notification!(resolver_name) if notify_existence?

      Messages::Expirer.new(message).call
    end

    def notify_message_created!(resolver_name, channel_id)
      build_message(resolver_name).create(
        channel_id:,
        reference_id: message.id
      )
    end

    def notify_message_expiration!
      @discord_message = message.external_message
      send_expired_message_notification!(
        @discord_message.channel_id,
        @discord_message.external_id
      )
    end

    private

    attr_reader :message

    def send_expired_message_notification!(channel_id, message_id)
      DiscordEngine::Message.new(
        content: EXPIRED_MESSAGE,
        components: []
      ).update(channel_id:, message_id:)
    end

    def send_message_existence_notification!(resolver_name)
      discord_message = message.external_message

      build_message(resolver_name).update(
        channel_id: discord_message.channel_id,
        message_id: discord_message.external_id
      )
    end

    def visit_based_visits_unreached?
      message.message_visits_count.to_i < message.expiration.limit
    end

    def notify_existence?
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

    def build_message(resolver_name)
      DiscordEngine::Message.new(
        content: MESSAGE_CREATED_CONTENT,
        components: build_non_expired_message_components(resolver_name)
      )
    end
  end
end
