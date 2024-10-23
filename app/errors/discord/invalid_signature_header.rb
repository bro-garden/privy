module Discord
  class InvalidSignatureHeader < StandardError
    def initialize
      super('Signature header is invalid')
    end
  end
end
