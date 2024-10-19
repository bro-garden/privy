module Privy
  module Integrations
    module Discord
      class API < Grape::API
        prefix '/discord'
        mount Interactions
      end
    end
  end
end
