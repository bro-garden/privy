class PrivyMessageExpiredListener
  NOTIFIAER_BY_INTERFACE_SOURCE = {
    Interface::DISCORD_GUILD_SOURCE => Notifications::DiscordNotifier
  }.freeze

  def privy_message_expired(payload)
    message = payload[:message]
    interface = message.interface
    notifier = NOTIFIAER_BY_INTERFACE_SOURCE[interface.source.to_sym]
    return unless notifier

    notifier.new(message).notify_message_expiration!
  end
end
