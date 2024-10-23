module Discord
  module Interactions
    module Callbacks
      class Callback
        class << self
          def create_pong
            Pong.new
          end
        end

        PONG_TYPE = 1

        attr_reader :type

        def initialize(type:)
          @type = type
        end
      end
    end
  end
end
