module Messages
  class Manager
    TIME_BASED_EXPIRATION_NAMES = %w[
      hour
      hours
      day
      days
      week
      weeks
      month
      months
    ].freeze
    VISITS_BASED_EXPIRATION_NAMES = %w[
      visit
      visits
    ].freeze

    def initialize(message)
      @message = message
    end

    def read_content
      return unless available?

      MessageVisit.create(message:)
      message.content
    end

    private

    attr_reader :message, :expiration

    def available?
      @expiration = message.expiration
      return false if message.read

      return time_based_available? if time_based_expiration?
      return visit_based_available? if visits_based_expiration?

      raise "Unknown expiration type: #{expiration.type}"
    end

    def time_based_available?
      current_time = Time.current.utc
      expires_at = message.created_at + expiration.limit.send(expiration.type)
      available = message.created_at <= current_time && current_time <= expires_at
      message.update(read: true) unless available

      available
    end

    def visit_based_available?
      available = message.message_visits.count < expiration.limit
      message.update(read: true) unless available

      available
    end

    def time_based_expiration?
      TIME_BASED_EXPIRATION_NAMES.include?(expiration.type)
    end

    def visits_based_expiration?
      VISITS_BASED_EXPIRATION_NAMES.include?(expiration.type)
    end
  end
end
