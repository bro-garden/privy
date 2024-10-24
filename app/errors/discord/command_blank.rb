module Discord
  class CommandBlank < StandardError
    def initialize
      super('A command name must be provided')
    end
  end
end
