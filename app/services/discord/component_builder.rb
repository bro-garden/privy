module Discord
  class ComponentBuilder
    attr_reader :components

    REVEAL_BUTTON_NAME = 'show_button'.freeze

    def initialize(resolver, message)
      @resolver = resolver
      @message = message
      @components = []
    end

    def build_show_button
      @data = { privy_id: message.id }
      @resolver_klass = resolver.class.command_name

      action_row_buttons = DiscordEngine::MessageComponents::ActionRow.new
      action_row_buttons.add(build_button)

      @components << action_row_buttons
    end

    private

    attr_reader :resolver, :message, :data, :resolver_klass

    def build_button
      DiscordEngine::MessageComponents::Button.new(
        label: 'Reveal',
        style: :success,
        resolver_klass:,
        name: REVEAL_BUTTON_NAME,
        data:
      )
    end
  end
end
