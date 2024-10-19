module Discord
  module Interactions
    class Request
      INTERACTION_TYPE = {
        PING: 1,
        APPLICATION_COMMAND: 2,
        MESSAGE_COMPONENT: 3,
        APPLICATION_COMMAND_AUTOCOMPLETE: 4,
        MODAL_SUBMIT: 5
      }.freeze

      attr_reader :raw_body, :application_id, :guild_id

      def initialize(params:, headers:, raw_body:)
        @request_headers = headers
        @raw_body = raw_body
        @params = params
        set_attributes
      end

      def headers
        @headers ||= RequestElements::Headers.new(request_headers:)
      end

      def user
        @user ||= RequestElements::User.new(request_params: params[:user])
      end

      def ping_type?
        request_type = params[:type].to_i
        INTERACTION_TYPE[:PING] == request_type
      end

      private

      attr_reader :params, :request_headers

      def set_attributes
        @application_id = params[:application_id]
        @guild_id = params[:guild_id]
      end
    end
  end
end
