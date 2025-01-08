status :created

json.uuid @message[:uuid]
json.expiration do
  json.duration "#{@message.expiration_limit} #{@message.expiration_type}"
  json.from @message.created_at
end
