module Discord
  module Listeners
    class HideOrExpireMessageListener
      def privy_message_read(payload)
        message = payload[:message]
        interface = message.interface
        return unless interface.discord_guild?

        Jobs::Messages::HideJob.set(wait: Jobs::Messages::HideJob::REVELATION_TIME).perform_later(message.id)
      end
    end
  end
end
