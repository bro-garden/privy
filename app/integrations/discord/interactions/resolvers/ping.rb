module Discord
  module Interactions
    module Resolvers
      class Ping < Resolver
        attr_reader :callback

        private

        def execute_action
          raise InvalidGlobalName, user unless correct_global_name?

          @callback = Resources::InteractionCallback.pong
        end

        def correct_global_name?
          user.discord?
        end
      end
    end
  end
end
