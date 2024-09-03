class Message < ApplicationRecord
  include EnumLoader

  load_enums_from_yaml

  has_many :message_visits, dependent: :destroy

  validates :content, presence: true
  validates :expiration_limit, numericality: { only_integer: true, greater_than: 0 }, allow_nil: false

  def expiration
    Struct.new(:limit, :type).new(
      expiration_limit, EXPIRATION_TYPE.find { |type| type.id == expiration_type }
    )
  end
end
