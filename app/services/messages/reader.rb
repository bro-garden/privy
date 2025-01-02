module Messages
  class Reader
    include Wisper::Publisher

    def initialize(message, visibility_time = nil, resolver_name = nil)
      @message = message
      @visibility_time = visibility_time
      @resolver_name = resolver_name
    end

    def read_message
      check_availability!
      track_visit
      broadcast(:message_read, { message:, visibility_time:, resolver_name: })

      read_content
    end

    private

    attr_reader :message, :visibility_time, :resolver_name

    def track_visit
      MessageVisit.create(message:)
    end

    def read_content
      message.content
    end

    def check_availability!
      return time_based_available? if expiration.time_based?
      return visit_based_available? if expiration.visits_based?

      raise Messages::ExpirationTypeError, message
    end

    def time_based_available?
      current_time = Time.current.utc
      expires_at = message.created_at + expiration.limit.public_send(expiration.type)
      return true if current_time <= expires_at

      raise Messages::ExpiredError, message
    end

    def visit_based_available?
      return true if message.message_visits_count.to_i < expiration.limit

      raise Messages::ExpiredError, message
    end

    def expiration
      message.expiration
    end
  end
end
