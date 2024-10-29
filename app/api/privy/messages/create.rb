module Privy
  module Messages
    class Create < Grape::API
      desc 'Creates a spline that can be reticulated.'
      params do
        requires :message, type: Hash do
          requires :content, type: String, desc: 'Content of the message.'
          requires :expiration_limit,
                   type: Integer,
                   desc: 'Amount, in terms of the expiration type, that the message will be available.'
          requires :expiration_type,
                   type: String,
                   desc: 'Type of expiration.',
                   values: ::Message.expiration_types.keys
        end
      end

      post '', jbuilder: 'messages/create' do
        message_params = declared(params, include_missing: false)[:message]
        creator = ::Messages::Creator.new(params: message_params, source: :api)
        creator.call
        @message = creator.message
      rescue ::Messages::CreationFailed => e
        return error!(e.message, 422)
      end
    end
  end
end
