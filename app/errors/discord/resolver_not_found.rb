module Discord
  class ResolverNotFound < StandardError
    attr_reader :interaction

    def initialize(interaction)
      @interaction = interaction
      super("Resolver #{interaction.type} not found")
    end
  end
end
