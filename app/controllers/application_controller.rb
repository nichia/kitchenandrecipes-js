class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user! #-> routes to the login / signup if not authenticated
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name])
  end

  # redirect users to the root_path
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
