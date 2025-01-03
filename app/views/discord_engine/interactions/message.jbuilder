json.type @resolver.callback.type
json.data do
  json.content @resolver.notice.content
  json.flags @resolver.flags
  json.components do
    json.array! @resolver.notice.components
  end
end
