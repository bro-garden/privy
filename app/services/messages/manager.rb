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
    EXPIRED = :expired

    def initialize(message)
      @message = message
    end

    def read_or_expires_message
      return expires_message unless available?

      read_content
    end

    private

    attr_reader :message, :expiration

    def read_content
      MessageVisit.create(message:)
      message.content
    end

    def expires_message
      message.update(read: true, content: '')
      EXPIRED
    end

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

      message.created_at <= current_time && current_time <= expires_at
    end

    def visit_based_available?
      message.message_visits.count < expiration.limit
    end

    def time_based_expiration?
      TIME_BASED_EXPIRATION_NAMES.include?(expiration.type)
    end

    def visits_based_expiration?
      VISITS_BASED_EXPIRATION_NAMES.include?(expiration.type)
    end
  end
end
