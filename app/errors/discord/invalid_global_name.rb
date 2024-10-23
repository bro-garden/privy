module Discord
  class InvalidGlobalName < StandardError
    attr_reader :user

    def initialize(user)
      @user = user
      super('Invalid global name for user')
    end
  end
end
