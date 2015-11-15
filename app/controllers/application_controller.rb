class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render 'shared/errors/404'
  end
end
