module TempMessages
  class API < Grape::API
    prefix '/temp-messages'
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    mount Messages::API => prefix
    mount Ping
  end
end
