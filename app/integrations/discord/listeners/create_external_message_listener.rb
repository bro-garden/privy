module Discord
  module Listeners
    class CreateExternalMessageListener
      def discord_engine_message_created(payload)
        DiscordMessages::Creator.new(params: payload[:response], message_uuid: payload[:reference_id]).call
      end
    end
  end
end
