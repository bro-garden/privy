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

      save_message!
      schedule_expiration
    rescue ActiveRecord::RecordInvalid => e
      raise CreationFailed, e.record.errors.full_messages.join(', ')
    end

    private

    attr_reader :source, :external_id, :params, :interface

    def save_message!
      message.save!
    end

    def schedule_expiration
      return unless message.expiration.time_based?

      ExpireJob.set(wait: message.expiration.wait_time).perform_later(message.id)
    end
  end
end
