Rails.application.reloader.to_prepare do
  Wisper.clear if Rails.env.development?

  Wisper.subscribe(Discord::Listeners::CreateExternalMessageListener.new)
  Wisper.subscribe(Discord::Listeners::SendExpiredNoticeListener.new)
  Wisper.subscribe(Discord::Listeners::HideOrExpireMessageListener.new)
  Wisper.subscribe(Messages::CheckMessageExpirationListener.new)
end
