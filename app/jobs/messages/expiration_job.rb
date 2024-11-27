module Messages
  class ExpirationJob < ApplicationJob
    queue_as :default

    def perform(message_id)
      @message = Message.find(message_id)
      Messages::Expirer.new(message).call
    rescue StandardError => e
      Rails.logger.error("Message with id #{e} not found")
    end
  end
end
