class UsersController < ApplicationController

  # GET /users/:id
  def show
    # Dropdown option 'My Dashboard' navbar avatar, and
    # when click on author of recipe link
    @user = User.find(params[:id])
    if @user == current_user
      @recipes = @user.recipes
    else
      @recipes = @user.recipes.public_recipes
    end
  end

end
