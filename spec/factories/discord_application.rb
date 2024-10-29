# spec/factories/discord_applications.rb
FactoryBot.define do
  factory :discord_application, class: 'DiscordEngine::Application' do
    id { Faker::Number.unique.number(digits: 18) }

    initialize_with { new(id:) }
  end
end
