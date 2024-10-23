module Discord
  module Resources
    class InteractionCallback
      class << self
        def pong
          new(type: PONG_TYPE)
        end
      end

      attr_reader :type

      PONG_TYPE = 1

      def initialize(type:)
        @type = type
      end
    end
  end
end
