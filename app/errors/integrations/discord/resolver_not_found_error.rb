module Integrations
  module Discord
    class ResolverNotFoundError < StandardError
      attr_reader :record

      def initialize(interaction)
        @record = interaction
        super("Resolver #{interaction.type} not found")
      end
    end
  end
end
