module Messages
  class ExpirationJob < ApplicationJob
    queue_as :default

    def perform(message_id)
      message = Message.find(message_id)
      Expirer.new(message).call
    rescue StandardError => e
      Rails.logger.error("Error at Messages::ExpirationJob: #{e.message}")
    end
  end
end
