FactoryBot.define do
  factory :message do
    content { 'Hello, World!' }
    expiration_limit { 1 }
    expiration_type { '0' }
    expired { false }
    uuid { UUID7.generate }

    association :interface

    trait :from_discord do
      interface { create(:interface, :from_discord) }
      external_message { create(:discord_message) }
    end
  end
end
