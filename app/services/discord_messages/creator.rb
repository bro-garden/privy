module DiscordMessages
  class Creator
    attr_reader :message

    def initialize(params:)
      @params = params
    end

    def call
      @message = DiscordMessage.new(channel_id: params['channel_id'], external_id: params['id'])

      @message.save!
    rescue ActiveRecord::RecordInvalid => e
      raise CreationFailed, e.record.errors.full_messages.join(', ')
    end

    private

    attr_reader :params
  end
end
