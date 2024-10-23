module Discord
  module Interactions
    module Callbacks
      class Pong < Callback
        def initialize
          super(type: PONG_TYPE)
        end
      end
    end
  end
end
