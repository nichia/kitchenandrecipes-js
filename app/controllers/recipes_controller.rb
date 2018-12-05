class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @recipes = Recipe.all_public
  end

  def create
  end

  def new
  end

  def edit
  end

  def show
    @recipe_ingredients = @recipe.recipe_ingredients
    @instructions = @recipe.instructions
  end

  def update
  end

  def destroy
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
end
