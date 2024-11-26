class MessageExpiration
  TIME_BASED_TYPES = %w[
    hour
    hours
    day
    days
    week
    weeks
    month
    months
  ].freeze
  VISITS_BASED_TYPES = %w[
    visit
    visits
  ].freeze

  attr_reader :limit, :type

  def initialize(limit, type)
    @limit = limit
    @type = type
  end

  def wait
    return if visits_based?

    limit.send(type)
  end

  def time_based?
    TIME_BASED_TYPES.include?(type)
  end

  def visits_based?
    VISITS_BASED_TYPES.include?(type)
  end
end
