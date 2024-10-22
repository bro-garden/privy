status :created

json.id @message[:id]
json.expiration do
  json.duration "#{@message.expiration_limit} #{@message.expiration_type}"
  json.from @message.created_at
end
