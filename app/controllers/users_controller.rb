class UsersController < ApplicationController

  # GET /users/:id
  def show
    # Dropdown option 'My Dashboard' navbar avatar, and
    # when click on author of recipe link
    @user = User.find(params[:id])
    @recipes = @user.recipes.public_and_current_user_recipes(current_user).page(params[:page])
  end

end
