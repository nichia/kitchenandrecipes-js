class WelcomeController < ApplicationController

  def home
    # navbar home button
    @recipes = Recipe.public_and_current_user_recipes(current_user).page(params[:page])
  end

end
