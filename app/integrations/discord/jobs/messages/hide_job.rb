module Discord
  module Jobs
    module Messages
      class HideJob < ApplicationJob
        queue_as :urgent

        REVELATION_TIME = 15.seconds

        def perform(message_id)
          message = Message.find(message_id)
          return expire_message(message) unless message.available?

          send_available_notice(message)
        end

        private

        def send_available_notice(message)
          notice = StatusNotices::Available.new(message).build
          notice.update(
            channel_id: message.external_message.channel_id,
            message_id: message.external_message.external_id
          )
        end

        def expire_message(message)
          ::Messages::Expirer.new(message).call
        end
      end
    end
  end
end
