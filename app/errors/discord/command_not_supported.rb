module Discord
  class CommandNotSupported < StandardError
    attr_reader :command_name

    def initialize(command_name)
      @command_name = command_name
      super("#{command_name} not supported")
    end
  end
end
