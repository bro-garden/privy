module Messages
  class API < Grape::API
    helpers do
      include Rails.application.routes.url_helpers

      def default_url_options
        { host: ENV['DEFAULT_URL_HOST'] }
      end
    end

    prefix '/api/messages'
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    mount Ping
    mount Post
  end
end
