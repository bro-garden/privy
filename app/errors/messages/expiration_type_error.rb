module Messages
  class ExpirationTypeError < StandardError
    attr_reader :record

    def initialize(message)
      @record = message
      super('Expiration type is not recognized')
    end
  end
end
