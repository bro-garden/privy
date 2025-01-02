class MessageReadListener
  VISIBILITY_JOB_MAP = {
    Interface::DISCORD_GUILD_SOURCE => DiscordMessages::VisibilityJob
  }.freeze

  def message_read(payload)
    message = payload[:message]
    visibility_time = payload[:visibility_time]
    resolver_name = payload[:resolver_name]
    interface = message.interface
    return unless visibility_time.present? && resolver_name.present?

    job = VISIBILITY_JOB_MAP[interface.source.to_sym]
    return unless job

    job.set(wait: visibility_time).perform_later(message.id, resolver_name)
  end
end
