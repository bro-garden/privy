class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    raise Messages::ContentBlankError, nil if message_params[:content].blank?

    interface = Interface.create(interface_type: :web)
    @message = Message.new(message_params.merge(interface:))
    @message.save!

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
