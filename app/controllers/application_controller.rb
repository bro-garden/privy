class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_with_error
  rescue_from Messages::ExpiredError, with: :redirect_with_error
  rescue_from ActiveRecord::RecordInvalid, with: :redirect_with_validation_error

  def redirect_with_error(error)
    flash[:alert] = error.message
    redirect_to root_path
  end

  def redirect_with_validation_error(error)
    flash[:alert] = error.record.errors.full_messages.join(', ')
    redirect_to root_path
  end

  def redirect_with_not_found_error(_error)
    flash[:alert] = 'Message not found'
    redirect_to root_path
  end
end
