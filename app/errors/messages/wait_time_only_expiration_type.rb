module Messages
  class WaitTimeOnlyExpirationType < StandardError
    def initialize
      super('Only time based expirations have a wait time')
    end
  end
end
