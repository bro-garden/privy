module Messages
  class Creator
    attr_reader :message

    def initialize(params:, source: nil, external_id: nil)
      @source = source
      @external_id = external_id
      @params = params
    end

    def call
      find_interface
      params.merge!({ interface: })
      @message = Message.new(params)

      @message.save!
    rescue ActiveRecord::RecordInvalid => e
      raise CreationFailed, e.record.errors.full_messages.join(', ')
    end

    private

    attr_reader :source, :external_id, :params, :interface

    def find_interface
      @interface = Interface.api if source == :api
      @interface = Interface.web if source == :web
      @interface = Interface.find_by(source:, external_id:) if @interface.blank?

      raise InterfaceNotFound, external_id unless @interface
    end
  end
end
