module Messages
  class ContentBlankError < StandardError
    attr_reader :record

    def initialize(message)
      @record = message
      super('Message content cannot be blank')
    end
  end
end
