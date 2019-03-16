class UsersController < ApplicationController

  # GET /users/:id
  def show
    # Dropdown option 'My Dashboard' navbar avatar, and
    # when click on author of recipe link
    @user = User.find(params[:id])
    @recipes = @user.recipes.public_and_current_user_recipes(current_user).page(params[:page])
  end

  def current_user_signed_in
    if current_user
      render json: current_user, status: 200
    else
      # render plain: "", status: 204
      render json: { error: 'User not signed in.' }, status: 404
    end
  end

end