class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    # if current_user.blank?
    #   redirect_to new_user_session_url
    # end
    @recipes = Recipe.all_public
  end

end
