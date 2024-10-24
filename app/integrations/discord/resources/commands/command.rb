module Discord
  module Resources
    module Commands
      class Command
        attr_reader :id, :integration_types, :contexts, :type

        CHAT_INPUT_TYPE = 1
        GUILD_CONTEXT = 0
        GUILD_INTEGRATION_TYPE = 0

        def initialize(type:, integration_types:, contexts:)
          @type = type
          @integration_types = integration_types
          @contexts = contexts
        end
      end
    end
  end
end
