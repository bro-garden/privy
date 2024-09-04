class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    return respond_to(&:turbo_stream) if @message.save

    fail_and_redirect_to_new(@message.errors.full_messages.join(', '))
  end

  def show
    @message = Message.find(params[:id])
    return fail_and_redirect_to_new('Message not found') unless @message

    message_manager = Messages::Manager.new(@message)
    @content = message_manager.read_or_expires_message
    return render :show if @content == Messages::Manager::EXPIRED

    fail_and_redirect_to_new('Message has expired')
  end

  private

  def message_params
    params.require(:message).permit(:content, :expiration_limit, :expiration_type)
  end

  def fail_and_redirect_to_new(message)
    flash[:alert] = message
    redirect_to new_message_path
  end
end
