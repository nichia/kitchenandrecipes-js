class ApiController < ApplicationController

  # GET /api/recipes
  # GET /api/users/:user_id/recipes
  def index
    # binding.pry
    if params[:id]
      user = User.find_by(id: params[:id])
      if user == nil
        render json: {errors: "This user #{params[:id]} does not exist"}, status: 404
      else
        recipes = user.recipes
        # render json: recipes, status: 200
        render json: recipes, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions'], status: 200
      end
    else
      recipes = Recipe.public_and_current_user_recipes(current_user)
      # render json: recipes, status: 200
      render json: recipes, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions'], status: 200
    end
  end


  # GET /api/recipes/:id
  def show
    # binding.pry
    recipe = Recipe.find_by(id: params[:id])
    if recipe == nil
      render json: {errors: "This recipe #{params[:id]} does not exist"}, status: 404
    elsif recipe.private && recipe.user != current_user  
      render json: {errors: "You don't have permision to access this recipe"}, status: 403
    else
      # render json: recipes, status: 200
      render json: recipe, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions'], status: 200
    end
  end
end
