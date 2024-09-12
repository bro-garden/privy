status :created

json.message do
  json.content @content.to_plain_text
end
