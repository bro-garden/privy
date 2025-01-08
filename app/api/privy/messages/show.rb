module Privy
  module Messages
    class Show < Grape::API
      desc 'Returns a message by uuid.'
      params do
        requires :uuid, type: String, desc: 'UUID of the message.'
      end

      get ':uuid', jbuilder: 'messages/show' do
        message = Message.find_by!(uuid: params[:uuid])
        @content = ::Messages::Reader.new(message).read_message
      rescue ActiveRecord::RecordNotFound => e
        return error!(e.message, :not_found)
      rescue ::Messages::ExpirationTypeError => e
        return error!(e.message, :unprocessable_entity)
      rescue ::Messages::ExpiredError => e
        return error!(e.message, :unauthorized)
      end
    end
  end
end
