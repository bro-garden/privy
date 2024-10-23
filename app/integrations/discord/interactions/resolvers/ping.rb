module Discord
  module Interactions
    module Resolvers
      class Ping < Resolver
        attr_reader :callback

        private

        def execute_action
          raise Integrations::Discord::InvalidSignatureHeaderError unless correct_global_name?

          @callback = Discord::Interactions::Callbacks::Callback.create_pong
        end

        def correct_global_name?
          user.discord?
        end
      end
    end
  end
end
