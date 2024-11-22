FactoryBot.define do
  factory :discord_message do
    external_id { Faker::Alphanumeric.alphanumeric(number: 10) }
    channel_id { Faker::Alphanumeric.alphanumeric(number: 10) }

    association :message
  end
end
