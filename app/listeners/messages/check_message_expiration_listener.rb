module Messages
  class CheckMessageExpirationListener
    def privy_message_read(payload)
      message = payload[:message]
      interface = message.interface
      return if message.available? || !interface.internal?

      ::Messages::Expirer.new(message).call
    end
  end
end
