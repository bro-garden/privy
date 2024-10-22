module Discord
  module Interactions
    module Resolvers
      class Resolver
        class << self
          def find(interaction:, **args)
            return Resolvers::Ping.new(**args) if interaction.ping_type?

            raise Integrations::Discord::ResolverNotFoundError, interaction
          end
        end

        PUBLIC_KEY = Rails.application.credentials.discord_application.public_key

        attr_reader :application, :guild, :user

        def initialize(request:, raw_body:, application:, guild:, user:)
          @headers = request.headers
          @params = request.params
          @raw_body = raw_body
          @application = application
          @guild = guild
          @user = user
        end

        def call
          return execute_action if valid_signature?

          raise Integrations::Discord::UnauthorizedRequestError
        end

        def name
          self.class.name.split('::').last.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
        end

        private

        attr_reader :params, :headers, :raw_body

        def execute_action
          raise NotImplementedError, "#{self.class} should implement 'call'"
        end

        def valid_signature?
          signature = headers_signature
          message = headers_signature_timestamp + raw_body
          public_key = RbNaCl::PublicKey.new([PUBLIC_KEY].pack('H*'))

          begin
            verify_key = RbNaCl::VerifyKey.new(public_key)
            verify_key.verify([signature].pack('H*'), message)
            true
          rescue RbNaCl::BadSignatureError
            false
          end
        end

        def headers_signature
          headers['x-signature-ed25519']
        end

        def headers_signature_timestamp
          headers['x-signature-timestamp']
        end
      end
    end
  end
end
