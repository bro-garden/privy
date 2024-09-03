class Message < ApplicationRecord
  enum expiration_type: {
    hour: "0",
    hours: "1",
    day: "2",
    days: "3",
    week: "4",
    weeks: "5",
    month: "6",
    months: "7"
  }

  has_many :message_visits, dependent: :destroy

  validates :content, presence: true
  validates :expiration_limit, numericality: { only_integer: true, greater_than: 0 }, presence: true
  validates :expiration_type, presence: true
  validates :read, inclusion: { in: [true, false] }, allow_nil: false

  def expiration
    Struct.new(:limit, :type).new(
      expiration_limit, expiration_type
    )
  end
end
