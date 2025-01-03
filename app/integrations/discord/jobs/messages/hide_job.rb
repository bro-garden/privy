module Discord
  module Jobs
    module Messages
      class HideJob < ApplicationJob
        queue_as :urgent

        REVELATION_TIME = 15.seconds

        def perform(message_id)
          message = Message.find(message_id)
          return if message.expired?

          notice = StatusNotices::Available.new(message).build
          notice.update(
            channel_id: message.external_message.channel_id,
            message_id: message.external_message.external_id
          )
        end
      end
    end
  end
end
