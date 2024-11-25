module DiscordMessages
  class Creator
    attr_reader :discord_message

    def initialize(params:, message_id:)
      @params = params
      @message_id = message_id
    end

    def call
      message = Message.find(message_id)
      @discord_message = DiscordMessage.new(
        channel_id: params['channel_id'],
        external_id: params['id'],
        message:
      )

      @discord_message.save!
    rescue ActiveRecord::RecordInvalid => e
      raise Messages::CreationFailed, e.record.errors.full_messages.join(', ')
    end

    private

    attr_reader :params, :message_id
  end
end
