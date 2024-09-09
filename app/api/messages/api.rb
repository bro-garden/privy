module Messages
  class API < Grape::API
    prefix '/api/messages'
    format :json
    mount Ping
  end
end
