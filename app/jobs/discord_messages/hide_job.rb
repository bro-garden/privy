module DiscordMessages
  class HideJob < ApplicationJob
    queue_as :urgent

    REVELATION_TIME = 15.seconds

    def perform(message_id)
      message = Message.find(message_id)
      return if message.expired?

      notice = Discord::StatusNotices::Available.new(message).build
      notice.update(
        channel_id: message.discord_message.channel_id,
        message_id: message.discord_message.external_id
      )
    end
  end
end
