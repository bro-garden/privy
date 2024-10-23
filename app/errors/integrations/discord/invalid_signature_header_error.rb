module Integrations
  module Discord
    class InvalidSignatureHeaderError < StandardError
      attr_reader :record

      def initialize
        super('Signature header is invalid')
      end
    end
  end
end
