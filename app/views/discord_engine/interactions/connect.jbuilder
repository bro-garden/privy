json.partial!(
  'discord_engine/partials/single_line',
  type: @resolver.callback.type,
  flags: @resolver.respond_to?(:flags) ? @resolver.flags : nil,
  content: @resolver.content
)
