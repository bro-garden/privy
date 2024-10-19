module Discord
  module Interactions
    module RequestElements
      class User
        attr_reader :id, :global_name, :username

        def initialize(request_params:)
          @request_params = request_params
          @id = request_params[:id]
          @global_name = request_params[:global_name]
          @username = request_params[:username]
        end

        private

        attr_reader :request_params
      end
    end
  end
end
