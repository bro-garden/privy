FactoryBot.define do
  factory :user, class: 'Discord::Resources::User' do
    id { Faker::Number.unique.number(digits: 20).to_s }
    global_name { Discord::Resources::User::EXPECTED_DISCORD_GLOBAL_NAME }
    username { Faker::Internet.username }

    skip_create
    initialize_with { new(**attributes) }
  end
end
