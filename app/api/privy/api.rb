module Privy
  class API < Grape::API
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    mount Messages::API
    mount Integrations::API => '/integrations'
    mount Ping
  end
end
