module Discord
  module Interactions
    module Resolvers
      class Resolver
        class << self
          def create_resolver(request:)
            Resolvers::Ping.new(request:) if request.ping_type?
          end
        end

        PUBLIC_KEY = ENV['PUBLIC_KEY']
        RESPONSE_STATUS = {
          OK: 200,
          UNAUTHORIZED: 401
        }.freeze

        attr_reader :response_status, :body

        def initialize(request:)
          @request = request
        end

        def call
          raise NotImplementedError, "#{self.class} should implement 'call'"
        end

        def name
          self.class.name.split('::').last.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
        end

        private

        attr_reader :request

        def valid_signature?
          signature = request.headers.signature
          message = request.headers.signature_timestamp + request.raw_body
          public_key = RbNaCl::PublicKey.new([PUBLIC_KEY].pack('H*'))

          begin
            verify_key = RbNaCl::VerifyKey.new(public_key)
            verify_key.verify([signature].pack('H*'), message)
            true
          rescue RbNaCl::BadSignatureError
            false
          end
        end
      end
    end
  end
end
