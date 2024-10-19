module Discord
  module Interactions
    module Resolvers
      class Ping < Resolver
        EXPECTED_GLOBAL_NAME = 'Discord'.freeze
        PONG_RESPONSE_TYPE = 1

        Response = Struct.new(:type)

        def call
          @response_status = RESPONSE_STATUS[:UNAUTHORIZED]
          @body = {}

          return unless valid_signature? && correct_global_name?

          @response_status = RESPONSE_STATUS[:OK]
          @body = Response.new(PONG_RESPONSE_TYPE)
        end

        private

        def correct_global_name?
          request.user.global_name == EXPECTED_GLOBAL_NAME
        end
      end
    end
  end
end
