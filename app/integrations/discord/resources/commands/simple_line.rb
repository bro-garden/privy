module Discord
  module Resources
    module Commands
      class SimpleLine < Command
        attr_reader :name, :description

        def initialize(name:, description:)
          super(type: CHAT_INPUT_TYPE, integration_types: [GUILD_INTEGRATION_TYPE], contexts: [GUILD_CONTEXT])
          @name = name
          @description = description
        end
      end
    end
  end
end
