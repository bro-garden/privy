class PrivyMessageExpiredListener
  NOTICES = {
    Interface::DISCORD_GUILD_SOURCE => :create_discord_notice
  }.freeze

  def privy_message_expired(payload)
    message = payload[:message]
    interface = message.interface
    notice_method = NOTICES[interface.source.to_sym]
    return unless notice_method

    send(notice_method, message)
  end

  private

  def create_discord_notice(message)
    notice = Discord::StatusNotices::Expired.new.build
    notice.update(
      channel_id: message.discord_message.channel_id,
      message_id: message.discord_message.external_id
    )
  end
end
