module Messages
  class Get < Grape::API
    desc 'Returns a message by id.'
    params do
      requires :id, type: Integer, desc: 'ID of the message.'
    end

    get ':id', jbuilder: 'messages/show' do
      message = Message.find(params[:id])
      @content = Messages::Reader.new(message).read_message
    rescue Messages::ExpirationTypeError => e
      return error!(e.message, 422)
    rescue Messages::ExpiredError => e
      return error!(e.message, 404)
    end
  end
end
