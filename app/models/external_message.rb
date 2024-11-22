class ExternalMessage < ApplicationRecord
  belongs_to :message, optional: true

  validates :external_id, presence: true, uniqueness: { scope: %i[type channel_id] }
  validates :channel_id, presence: true
  validates :type, presence: true
end
