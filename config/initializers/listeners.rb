Rails.application.reloader.to_prepare do
  Wisper.clear if Rails.env.development?

  Wisper.subscribe(CreateExternalMessageListener.new)
end
