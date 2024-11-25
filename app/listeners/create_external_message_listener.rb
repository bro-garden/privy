class CreateExternalMessageListener
  def discord_engine_message_created(payload)
    DiscordMessages::Creator.new(params: payload[:response], message_id: payload[:reference_id]).call
  end
end
