# spec/factories/discord_guilds.rb
FactoryBot.define do
  factory :discord_guild, class: 'DiscordEngine::Guild' do
    id { Faker::Number.unique.number(digits: 18) }

    initialize_with { new(id:) }
  end
end
