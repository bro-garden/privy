module Privy
  module Messages
    class API < Grape::API
      prefix '/messages'
      mount Create
      mount Show
    end
  end
end
