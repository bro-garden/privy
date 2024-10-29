module Messages
  class Creator
    attr_reader :message

    def initialize(params:, source: nil, external_id: nil)
      @source = source
      @external_id = external_id
      @params = params
    end

    def call
      interface_resolver = Interfaces::Resolver.new(source:, external_id:)
      interface_resolver.find_interface
      params.merge!({ interface: interface_resolver.interface })
      @message = Message.new(params)

      @message.save!
    rescue ActiveRecord::RecordInvalid => e
      raise CreationFailed, e.record.errors.full_messages.join(', ')
    end

    private

    attr_reader :source, :external_id, :params
  end
end
