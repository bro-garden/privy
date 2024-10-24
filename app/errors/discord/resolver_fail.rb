module Discord
  class ResolverFail < StandardError
    def initialize(resolver_name)
      super("#{resolver_name} failed")
    end
  end
end
