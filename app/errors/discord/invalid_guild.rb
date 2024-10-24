module Discord
  class InvalidGuild < StandardError
    attr_reader :interface

    def initialize(interface)
      @interface = interface

      super("error: #{interface.errors.full_messages.join(', ')}")
    end
  end
end
