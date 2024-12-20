class ExternalMessage < ApplicationRecord
  belongs_to :message

  validates :external_id, presence: true, uniqueness: { scope: %i[channel_id] }
  validates :channel_id, presence: true
  validates :type, presence: true
end
