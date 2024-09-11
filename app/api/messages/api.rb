module Messages
  class API < Grape::API
    helpers do
      include Rails.application.routes.url_helpers

      # Definir default_url_options para que Grape lo reconozca
      def default_url_options
        { host: ENV['DEFAULT_URL_HOST'] } # Cambia este host según tu entorno (desarrollo, producción, etc.)
      end
    end

    prefix '/api/messages'
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    mount Ping
    mount Post
  end
end
