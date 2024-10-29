module Messages
  class CreationFailed < StandardError
    def initialize(error_message = 'message creation failed')
      super(error_message)
    end
  end
end
