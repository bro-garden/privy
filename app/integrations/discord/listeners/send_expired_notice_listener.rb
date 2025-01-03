module Discord
  module Listeners
    class SendExpiredNoticeListener
      def privy_message_expired(payload)
        message = payload[:message]
        interface = message.interface
        return unless interface.discord_guild?

        create_discord_notice(message)
      end

      private

      def create_discord_notice(message)
        notice = Discord::StatusNotices::Expired.new.build
        notice.update(
          channel_id: message.discord_message.channel_id,
          message_id: message.discord_message.external_id
        )
      end
    end
  end
end
