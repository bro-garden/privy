status :created

json.url "#{ENV['DEFAULT_URL_HOST']}/api/messages/#{@message[:id]}"
json.expiration do
  json.duration "#{@message.expiration_limit} #{@message.expiration_type}"
  json.from @message.created_at
end
