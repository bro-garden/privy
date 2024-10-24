class Message < ApplicationRecord
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

  belongs_to :interface

  has_rich_text :content, encrypted: true

  validates :content, presence: true
  validates :expiration_limit, numericality: { only_integer: true, greater_than: 0 }, presence: true
  validates :expiration_type, presence: true
  validates :read, inclusion: { in: [true, false] }, allow_nil: false

  def expiration
    MessageExpiration.new(expiration_limit, expiration_type)
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
end
