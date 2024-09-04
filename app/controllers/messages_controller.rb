class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    return respond_to(&:turbo_stream) if @message.save

    render :new, status: :unprocessable_entity
  end

  def show
    @message = Message.find(params[:id])
    return fail_show('Message not found') unless @message

    message_manager = Messages::Manager.new(@message)
    @content = message_manager.read_content
    return render :show if @content.present?

    fail_show('Message has expired')
  end

  private

  def message_params
    params.require(:message).permit(:content, :expiration_limit, :expiration_type)
  end

  def fail_show(message)
    flash[:alert] = message
    redirect_to new_message_path
  end
end
