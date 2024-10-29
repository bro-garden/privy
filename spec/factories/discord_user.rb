# spec/factories/discord_users.rb
FactoryBot.define do
  factory :discord_user, class: 'DiscordEngine::User' do
    id { Faker::Number.unique.number(digits: 18) }
    global_name { Faker::Internet.username(specifier: 3..10) }
    username { Faker::Internet.username(specifier: 3..10) }

    initialize_with { new(id:, global_name:, username:) }
  end
end
