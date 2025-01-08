module DiscordMessages
  class Creator
    attr_reader :discord_message

    def initialize(params:, message_uuid:)
      @params = params
      @message_uuid = message_uuid
    end

    def call
      message = Message.find_by!(uuid: message_uuid)
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

    attr_reader :params, :message_uuid
  end
end
