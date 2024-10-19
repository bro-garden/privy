module Discord
  module Interactions
    module RequestElements
      class Headers
        def initialize(request_headers:)
          @request_headers = request_headers
        end

        def signature
          @signature ||= request_headers['x-signature-ed25519']
        end

        def signature_timestamp
          @signature_timestamp ||= request_headers['x-signature-timestamp']
        end

        private

        attr_reader :request_headers
      end
    end
  end
end
