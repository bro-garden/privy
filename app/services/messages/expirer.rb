module Messages
  class Expirer
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def call
      expire_message!
      notify_to_external_interface!
    end

    private

    def expire_message!
      message.update!(
        expired: true,
        expired_at: Time.zone.now
      )
    end

    def notify_to_external_interface!
      interface = message.interface
      Notifications::DiscordNotifier.new(message).notify_message_expiration! if interface.source == 'discord_guild'
    end
  end
end
