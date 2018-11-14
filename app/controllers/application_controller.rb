class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  # redirect users to the origin or root_path if the origin path is nil
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || root_path
  end
end
