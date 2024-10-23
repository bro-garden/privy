module Discord
  module Interactions
    module Resolvers
      class Ping < Resolver
        attr_reader :type

        private

        def execute_action
          raise Integrations::Discord::InvalidSignatureHeaderError unless correct_global_name?

          @type = Discord::Resources::Interaction::PONG_TYPE
        end

        def correct_global_name?
          user.discord?
        end
      end
    end
  end
end
