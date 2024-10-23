module Privy
  module Integrations
    class API < Grape::API
      mount Discord::API
    end
  end
end
