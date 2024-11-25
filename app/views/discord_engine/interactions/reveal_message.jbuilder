json.type @resolver.callback.type
json.data do
  json.content @resolver.content
  json.components do
    json.array! @resolver.components
  end
end
