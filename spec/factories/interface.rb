FactoryBot.define do
  factory :interface do
    external_id { Faker::Alphanumeric.alphanumeric(number: 10) }
    source { %w[discord_guild web api].sample }

    trait :from_discord do
      source { 'discord_guild' }
    end
  end
end
