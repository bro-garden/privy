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


# {"Version"=>"HTTP/1.1", "Host"=>"2fbc-190-84-136-36.ngrok-free.app", "User-Agent"=>"Discord-Interactions/1.0 (+https://discord.com)", "x-forwarded-for"=>"35.237.4.214", "x-forwarded-host"=>"2fbc-190-84-136-36.ngrok-free.app", "x-forwarded-proto"=>"https", "x-signature-ed25519"=>"ca2423d0ef2f217d8a5be8afe0a23b61817da2a402fb0bfc81b5f5a6c1d75eec760deab4a173e2c764b406f87b66b2a631222f1d4e1e739738a8e8d7db636909", "x-signature-timestamp"=>"1729608499", "Accept-Encoding"=>"gzip"}
# {"app_permissions"=>"562949953601536", "application_id"=>"1296566140188754081", "authorizing_integration_owners"=>{}, "entitlements"=>[], "id"=>"1298296889115934751", "token"=>"aW50ZXJhY3Rpb246MTI5ODI5Njg4OTExNTkzNDc1MTpxYmxjYXNJeDZlOTN0dzB3eDU5aTVvV0Nnd05MbzZKb0VFTW8yWEZjeXJ1ZklZQnlWM05jdVVmbDRSaXdJeXJBRms5VFN2aFVYVHBYNVk3U3I2S0oxdFJKb2FqdWVHOHJWejFyR0pkMkRWSW1zSEhjaXZhOWFYUXc0ODljeVM1Tw", "type"=>1, "user"=>{"avatar"=>"c6a249645d46209f337279cd2ca998c7", "avatar_decoration_data"=>nil, "bot"=>true, "clan"=>nil, "discriminator"=>"0000", "global_name"=>"Discord", "id"=>"643945264868098049", "public_flags"=>1, "system"=>true, "username"=>"discord"}, "version"=>1}
# 
#"{\"app_permissions\":\"562949953601536\",\"application_id\":\"1296566140188754081\",\"authorizing_integration_owners\":{},\"entitlements\":[],\"id\":\"1298296889115934751\",\"token\":\"aW50ZXJhY3Rpb246MTI5ODI5Njg4OTExNTkzNDc1MTpxYmxjYXNJeDZlOTN0dzB3eDU5aTVvV0Nnd05MbzZKb0VFTW8yWEZjeXJ1ZklZQnlWM05jdVVmbDRSaXdJeXJBRms5VFN2aFVYVHBYNVk3U3I2S0oxdFJKb2FqdWVHOHJWejFyR0pkMkRWSW1zSEhjaXZhOWFYUXc0ODljeVM1Tw\",\"type\":1,\"user\":{\"avatar\":\"c6a249645d46209f337279cd2ca998c7\",\"avatar_decoration_data\":null,\"bot\":true,\"clan\":null,\"discriminator\":\"0000\",\"global_name\":\"Discord\",\"id\":\"643945264868098049\",\"public_flags\":1,\"system\":true,\"username\":\"discord\"},\"version\":1}"