module Discord
  module Listeners
    class ExpireMessageListener
      def privy_message_read(payload)
        message = payload[:message]
        interface = message.interface
        return unless interface.discord_guild?
        return if message.available?

        Messages::Expirer.new(message).call
      end
    end
  end
end
