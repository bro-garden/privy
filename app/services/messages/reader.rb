module Messages
  class Reader
    include Wisper::Publisher

    def initialize(message)
      @message = message
    end

    def read_message
      check_availability!
      track_visit!

      content = read_content
      message.reload
      broadcast(:privy_message_read, { message: })
      content
    end

    private

    attr_reader :message

    def track_visit!
      MessageVisit.create!(message:)
    end

    def read_content
      message.content
    end

    def check_availability!
      return true if message.available?

      raise Messages::ExpiredError, message
    end
  end
end
