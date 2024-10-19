require 'faker'
require 'json'

# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/CyclomaticComplexity
# rubocop: disable Metrics/PerceivedComplexity
module Integrations
  module Discord
    module Interactions
      class PingInteraction
        TYPE = 1

        def initialize(
          app_permissions: nil,
          application_id: nil,
          authorizing_integration_owners: nil,
          entitlements: nil,
          id: nil,
          token: nil,
          user: nil
        )
          @app_permissions = app_permissions || Faker::Number.number(digits: 18).to_s
          @application_id = application_id || Faker::Number.number(digits: 19).to_s
          @authorizing_integration_owners = authorizing_integration_owners || {}
          @entitlements = entitlements || []
          @id = id || Faker::Number.number(digits: 19).to_s
          @token = token || Faker::Alphanumeric.alphanumeric(number: 64)
          @type = TYPE
          @user = user || User.new
        end

        def to_h
          {
            app_permissions:,
            application_id:,
            authorizing_integration_owners:,
            entitlements:,
            id:,
            token:,
            type:,
            user: user.to_h
          }
        end

        private

        attr_reader :app_permissions, :application_id, :authorizing_integration_owners,
                    :entitlements, :id, :token, :type, :user
      end
    end
  end
end
# rubocop: enable Metrics/PerceivedComplexity
# rubocop: enable Metrics/CyclomaticComplexity
# rubocop: enable Metrics/ParameterLists
