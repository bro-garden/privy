module Notifications
  class DiscordNotifier
    attr_reader :discord_message

    EXPIRED_MESSAGE = '⚠️ This message has expired'.freeze

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

    private

    attr_reader :message

    def send_expired_message_notification!(channel_id, message_id)
      DiscordEngine::Message.new(
        content: EXPIRED_MESSAGE,
        components: []
      ).update(channel_id:, message_id: message_id)
    end
  end
end
