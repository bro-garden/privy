module Messages
  class ExpirationJob < ApplicationJob
    queue_as :default

    def perform(message_id)
      message = Message.find(message_id)
      Expirer.new(message).call
    end
  end
end
