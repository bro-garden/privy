module Discord
  module Resources
    class InteractionCallback
      class << self
        def pong
          new(type: PONG_TYPE)
        end

        def channel_message_with_source
          new(type: CHANNEL_MESSAGE_WITH_SOURCE_TYPE)
        end
      end

      attr_reader :type

      PONG_TYPE = 1
      CHANNEL_MESSAGE_WITH_SOURCE_TYPE = 4

      def initialize(type:)
        @type = type
      end
    end
  end
end
