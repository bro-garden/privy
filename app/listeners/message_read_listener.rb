class MessageReadListener
  HIDE_JOBS = {
    Interface::DISCORD_GUILD_SOURCE => DiscordMessages::HideJob
  }.freeze

  def message_read(payload)
    message = payload[:message]
    interface = message.interface
    return enqueue_expire_job(interface, message) unless message.available?

    enqueue_hide_job(interface, message)
  end

  private

  def enqueue_expire_job(message)
    Messages::ExpireJob.perform_later(message.id)
  end

  def enqueue_hide_job(interface, message)
    job = HIDE_JOBS[interface.source.to_sym]
    return unless job

    job.set(wait: job::REVELATION_TIME).perform_later(message.id)
  end
end
