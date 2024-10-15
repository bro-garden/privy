module TempMessages
  module Messages
    class API < Grape::API
      prefix '/messages'
      mount Post
      mount Get
    end
  end
end
