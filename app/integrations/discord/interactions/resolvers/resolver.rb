module Discord
  module Interactions
    module Resolvers
      class Resolver
        class << self
          def find(interaction:, **args)
            return Resolvers::Ping.new(**args) if interaction.ping_type?

            raise ResolverNotFound, interaction
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
          raise InvalidSignatureHeader unless valid_signature?

          execute_action
        end

        def name
          self.class.name.split('::').last.underscore
        end

        private

        attr_reader :params, :headers, :raw_body

        def execute_action
          raise NotImplementedError, "#{self.class} should implement 'call'"
        end

        def valid_signature?
          message = signature_timestamp + raw_body
          public_key = RbNaCl::PublicKey.new([PUBLIC_KEY].pack('H*'))

          verify_key = RbNaCl::VerifyKey.new(public_key)
          verify_key.verify([signature].pack('H*'), message)
          true
        rescue RbNaCl::BadSignatureError
          false
        end

        def signature
          headers['x-signature-ed25519']
        end

        def signature_timestamp
          headers['x-signature-timestamp']
        end
      end
    end
  end
end
