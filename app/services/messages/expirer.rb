module Messages
  class Expirer
    attr_reader :message

    def initialize(message_id)
      @message_id = message_id
    end

    def call
      message = Message.find(message_id)
      expire_message!(message)
      expire_message_at_interface!(message)
    end

    private

    attr_reader :message_id

    def expire_message!(message)
      message.update!(
        expired: true,
        expired_at: Time.zone.now
      )
    end

    def expire_message_at_interface!(message)
      interface = message.interface
      Notifications::DiscordNotifier.new(message).notify_message_expiration! if interface.source == 'discord_guild'
    end
  end
end
