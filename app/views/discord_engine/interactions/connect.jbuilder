json.partial!(
  'discord_engine/partials/single_line',
  type: @resolver.callback.type,
  flags: @resolver.try(:flags),
  content: @resolver.content
)
