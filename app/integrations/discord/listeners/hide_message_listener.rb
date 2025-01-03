module Discord
  module Listeners
    class HideMessageListener
      def privy_message_read(payload)
        message = payload[:message]
        interface = message.interface
        return unless interface.discord_guild?
        return unless message.available?

        enqueue_hide_job(message)
      end

      private

      def enqueue_hide_job(message)
        Jobs::Messages::HideJob.set(wait: Jobs::Messages::HideJob::REVELATION_TIME).perform_later(message.id)
      end
    end
  end
end
