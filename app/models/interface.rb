class Interface < ApplicationRecord
  enum interface_type: { discord_guild: 0, web: 1, api: 2 }

  before_save :ensure_single_instance, if: -> { api? || web? }

  has_many :messages, dependent: :destroy

  validates :interface_type, presence: true
  validates :external_id, presence: true, if: :requires_external_id?
  validates :external_id, uniqueness: { scope: :interface_type }, if: :requires_external_id?

  private

  def ensure_single_instance
    existing_interface = Interface.find_by(interface_type:)

    return unless existing_interface

    self.external_id = existing_interface.external_id
    self.created_at = existing_interface.created_at
    self.id = existing_interface.id

    # mark it as not new
    @new_record = false
  end

  def requires_external_id?
    !web? && !api?
  end
end
