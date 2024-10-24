FactoryBot.define do
  factory :interface do
    external_id { Faker::Alphanumeric.alphanumeric(number: 10) }
    interface_type { %w[discord_guild web api].sample }
  end
end
