module Integrations
  module Discord
    class UnauthorizedRequestError < StandardError
      attr_reader :record

      def initialize
        super('Unauthorized request')
      end
    end
  end
end
