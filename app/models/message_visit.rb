class MessageVisit < ApplicationRecord
  belongs_to :message, counter_cache: true
end
