module Messages
  class Creator
    attr_reader :message

    def initialize(params:, source: nil, external_id: nil)
      @source = source
      @external_id = external_id
      @params = params
    end

    def call
      @interface = Interfaces::Resolver.new(source:, external_id:).call
      params.merge!({ interface: })
      @message = Message.new(params)

      @message.save!
    rescue ActiveRecord::RecordInvalid => e
      raise CreationFailed, e.record.errors.full_messages.join(', ')
    end

    private

    attr_reader :source, :external_id, :params, :interface
  end
end
