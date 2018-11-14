class WelcomeController < ApplicationController
  def home
    if current_user.blank?
      redirect_to new_user_session
    end
  end

  def index
  end
end
