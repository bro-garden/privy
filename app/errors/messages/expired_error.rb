module Messages
  class ExpiredError < StandardError
    attr_reader :record

    def initialize(message)
      @record = message
      super('Message has expired')
    end
  end
end
