module TempMessage
  module Messages
    class Show < Grape::API
      desc 'Returns a message by id.'
      params do
        requires :id, type: Integer, desc: 'ID of the message.'
      end

      get ':id', jbuilder: 'messages/show' do
        message = Message.find(params[:id])
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
