class CreateExternalMessageListener
  def discord_engine_message_created(payload)
    DiscordMessages::Creator.new(params: payload[:response]).call
  end
end
