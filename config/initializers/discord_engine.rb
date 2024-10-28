DiscordEngine.public_key = Rails.application.credentials.discord_application.public_key
DiscordEngine.bot_token = Rails.application.credentials.discord_application.bot_token
DiscordEngine.application_id = Rails.application.credentials.discord_application.id

DiscordEngine.command_resolvers = [
  'Discord::Interactions::Resolvers::SayHi',
  'Discord::Interactions::Resolvers::Connect'
]
