json.type @resolver.callback.type
json.data do
  json.content @resolver.content
  json.flags @resolver.flags
  json.components do
    json.array! @resolver.components
  end
end
