DiscordEngine.public_key = Rails.application.credentials.discord_application.public_key
DiscordEngine.bot_token = Rails.application.credentials.discord_application.bot_token
DiscordEngine.application_id = Rails.application.credentials.discord_application.id

DiscordEngine.resolvers = [
  'Discord::Interactions::Resolvers::SayHi',
  'Discord::Interactions::Resolvers::Connect'
]

DiscordEngine.guild_verification = ->(guild) { ::Interface.discord_guild.find_by(external_id: guild.id).present? }
