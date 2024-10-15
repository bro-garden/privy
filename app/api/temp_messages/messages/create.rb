module TempMessages
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
                   values: %w[hour hours day days week weeks month months visit visits]
        end
      end

      post '', jbuilder: 'messages/create' do
        @message = ::Message.new(params[:message])
        @message.save!
      rescue ActiveRecord::RecordInvalid
        return error!(@message.errors.full_messages, 422)
      end
    end
  end
end
