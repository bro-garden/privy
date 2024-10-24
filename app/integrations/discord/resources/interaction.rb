module Discord
  module Resources
    class Interaction
      PING_TYPE = 1
      APPLICATION_COMMAND_TYPE = 2
      MESSAGE_COMPONENT_TYPE = 3

      attr_reader :type

      def initialize(type:)
        @type = type.to_i
      end

      def ping_type?
        type == PING_TYPE
      end

      def application_command_type?
        type == APPLICATION_COMMAND_TYPE
      end
    end
  end
end
