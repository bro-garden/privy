module Discord
  class PrivyCreator
    PRIVY_MESSAGE_CREATED_CONTENT = 'Hey @everyone! here is a new **privy** message'.freeze

    def initialize(resolver:, channel_id:, message_params:, guild:)
      @message_params = message_params
      @guild = guild
      @channel_id = channel_id
      @resolver = resolver
    end

    def call
      message = create_privy_message
      create_message_at_discord(message)
      # TODO: with the response of creating a message, relate privy message with discord message
    end

    private

    attr_reader :message_params, :guild, :resolver, :channel_id

    def create_privy_message
      message_creator = Messages::Creator.new(
        params: message_params,
        source: :discord_guild,
        external_id: guild.id
      )
      message_creator.call

      message_creator.message
    end

    def create_message_at_discord(message)
      component_builder = Discord::ComponentBuilder.new(resolver, message)
      component_builder.build_show_button

      message = DiscordEngine::Message.new(
        content: PRIVY_MESSAGE_CREATED_CONTENT,
        components: component_builder.components
      ).create(channel_id:)
    end
  end
end
