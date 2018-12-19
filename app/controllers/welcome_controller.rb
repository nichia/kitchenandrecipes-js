class WelcomeController < ApplicationController

  def home
    # if current_user.blank?
    #   redirect_to new_user_session_url
    # end
    @recipes = Recipe.public_recipes
  end

end
