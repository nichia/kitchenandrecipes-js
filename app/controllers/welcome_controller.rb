class WelcomeController < ApplicationController

  def home
    # if current_user.blank?
    #   redirect_to new_user_session_url
    # end
    # navbar home button
    if user_signed_in?
      @recipes = Recipe.public_or_user_recipes(current_user)
    else
      @recipes = Recipe.public_recipes
    end
  end

end
