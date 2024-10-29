class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    creator = Messages::Creator.new(params: message_params, source: :web)
    creator.call
    @message = creator.message

    respond_to(&:turbo_stream)
  end

  def show
    @content = Messages::Reader.new(message).read_message
  end

  private

  def message_params
    params.require(:message).permit(:content, :expiration_limit, :expiration_type)
  end

  def message
    @message ||= Message.find(params[:id])
  end
end
