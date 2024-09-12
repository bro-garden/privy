module Messages
  class API < Grape::API
    prefix '/api/messages'
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    mount Ping
    mount Post
    mount Get
  end
end
