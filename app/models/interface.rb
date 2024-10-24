class Interface < ApplicationRecord
  enum interface_type: { discord_guild: 0, web: 1, api: 2 }

  has_many :messages, dependent: :destroy

  validates :interface_type, presence: true
  validates :external_id, presence: true, if: :requires_external_id?

  class << self
    def web
      find_or_create_by(interface_type: :web)
    end

    def api
      find_or_create_by(interface_type: :api)
    end
  end

  private

  def requires_external_id?
    !web? && !api?
  end
end
