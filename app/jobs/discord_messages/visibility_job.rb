module DiscordMessages
  class VisibilityJob < ApplicationJob
    queue_as :urgent

    def perform(message_id, resolver_name)
      message = Message.find(message_id)
      return if message.expired?

      Notifications::DiscordNotifier.new(message).notify_message_state!(resolver_name)
    end
  end
end
