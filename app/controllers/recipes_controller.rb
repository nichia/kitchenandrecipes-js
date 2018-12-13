class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @recipes = Recipe.public_recipes
  end

  def create
    raise params.inspect
    @recipes = Recipe.new(recipe_params)
    if @recipe.save
      redirect_to recipe_url(@recipe)
    else
      render :new
    end
  end

  def new
    @recipe = Recipe.new
    @categories = Category.by_type
    @ingredients = Ingredient.all
    @measurements = Measurement.all
    @recipe.categories.build(category_type: "meal")
    @recipe.categories.build(category_type: "cuisine")
    @recipe.categories.build(category_type: "dish")
    @recipe.instructions.build
    @recipe.recipe_ingredients.build
    #binding.pry
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

    def recipe_params
      params.require(:recipe).permit(
        :name,
        :description,
        :prep_time,
        :cook_time,
        :yield,
        :yield_size,
        :private,
        :source,
        :image,
        :categories_ids => [],
        :categories_attributes => [:category_type, :name],
        :recipe_ingredients_attributes => [:name, :quantity, :measurement_id],
        :instructions_attributes => [:id, :description, :_destroy]
      )
    end
end
