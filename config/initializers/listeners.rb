Rails.application.reloader.to_prepare do
  Wisper.clear if Rails.env.development?

  Wisper.subscribe(CreateExternalMessageListener.new)
  Wisper.subscribe(PrivyMessageExpiredListener.new)
  Wisper.subscribe(MessageReadListener.new)
end
