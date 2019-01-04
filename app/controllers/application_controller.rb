class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # routes to the login / signup if not authenticated
  before_action :authenticate_user!, :except => [:home, :show, :index, :search]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :first_name, :last_name, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :first_name, :last_name, :avatar])
  end

  # redirect users to the root_path
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
