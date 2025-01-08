class Interface < ApplicationRecord
  INTERNAL_SOURCES = %i[web api].freeze
  EXTERNAL_SOURCES = [:discord_guild].freeze

  enum source: { discord_guild: 0, web: 1, api: 2 }

  has_many :messages, dependent: :destroy

  validates :source, presence: true
  validates :external_id, presence: true, uniqueness: { scope: :source }, unless: :internal?
  validate :unique_source, if: :internal?

  scope :api, -> { find_by(source: :api) }
  scope :web, -> { find_by(source: :web) }

  def internal?
    return false unless source

    INTERNAL_SOURCES.include?(source.to_sym)
  end

  private

  def unique_source
    return unless self.class.where(source:).where.not(id:).exists?

    errors.add(:source, 'internal sources must be unique')
  end
end
