module Messages
  class InterfaceNotFound < CreationFailed
    def initialize(external_id)
      super("interface with external id: #{external_id} not found")
    end
  end
end
