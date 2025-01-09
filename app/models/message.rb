class Message < ApplicationRecord
  include Uuidable

  enum expiration_type: {
    hour: '0',
    hours: '1',
    day: '2',
    days: '3',
    week: '4',
    weeks: '5',
    month: '6',
    months: '7',
    visit: '8',
    visits: '9'
  }

  before_create :set_dates
  after_update :set_updated_at

  has_many :message_visits, dependent: :destroy
  has_one :external_message, dependent: :destroy

  belongs_to :interface

  has_rich_text :content, encrypted: true

  validates :content, presence: true, unless: :expired
  validates :expiration_limit, numericality: { only_integer: true, greater_than: 0 }, presence: true
  validates :expiration_type, presence: true
  validates :expired, inclusion: { in: [true, false] }, allow_nil: false

  def expiration
    MessageExpiration.new(expiration_limit, expiration_type)
  end

  def available?
    return time_based_available? if expiration.time_based?
    return visit_based_available? if expiration.visits_based?

    raise Messages::ExpirationTypeError, self
  end

  private

  def set_dates
    date = Time.current.utc
    self.created_at = date
    self.updated_at = date
  end

  def set_updated_at
    self.updated_at = Time.current.utc
  end

  def time_based_available?
    current_time = Time.current.utc
    expires_at = created_at + expiration.limit.public_send(expiration.type)
    return true if current_time <= expires_at

    false
  end

  def visit_based_available?
    return true if message_visits_count.to_i < expiration.limit

    false
  end
end
