module DiscordMessages
  class VisibilityJob < ApplicationJob
    queue_as :urgent

    def perform(message_id, resolver_name)
      @message = Message.find(message_id)
      return if message.expired?

      Notifications::DiscordNotifier.new(message).notify_message_hidden!(resolver_name)
    rescue StandardError => e
      Rails.logger.error("Error at DiscordMessages::VisibilityJob: #{e.message}")
    end

    private

    attr_reader :message
  end
end