module Messages
  class Expirer
    include Wisper::Publisher

    attr_reader :message

    def initialize(message)
      @message = message
    end

    def call
      expire_message!
      broadcast(:privy_message_expired, { message: })
    end

    private

    def expire_message!
      message.update!(
        expired: true,
        expired_at: Time.zone.now
      )
    end
  end
end
