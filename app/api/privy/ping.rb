module Privy
  class Ping < Grape::API
    desc 'Returns pong.'
    get :ping do
      { ping: 'pong' }
    end
  end
end
