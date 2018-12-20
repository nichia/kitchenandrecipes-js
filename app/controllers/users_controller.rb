class UsersController < ApplicationController

   # GET /recipes/:id
   def show
     @user = User.find(params[:id])
     if @user == current_user
       @recipes = @user.recipes
     else
       @recipes = @user.recipes.public_recipes
     end
   end

end
