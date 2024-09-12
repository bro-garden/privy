status :created

json.url message_url(@message)
json.expiration do
  json.duration "#{@message.expiration_limit} #{@message.expiration_type}"
  json.from @message.created_at
end
