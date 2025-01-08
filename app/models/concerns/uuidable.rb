module Uuidable
  extend ActiveSupport::Concern

  included do
    before_create :generate_uuid
  end

  private

  def generate_uuid
    loop do
      uuid = UUID7.generate
      next if self.class.exists?(uuid:)

      self.uuid = uuid
      break
    end
  end
end
