class MessageExpirationJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    Messages::Expirer.new(message_id).call
  rescue StandardError => e
    Rails.logger.error("Message with id #{e} not found")
  end
end
