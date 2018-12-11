class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @recipes = Recipe.public_recipes
  end

  def create
    raise params.inspect
    # prep_time = "#{params[:recipe]['prep_time(4i)']}:#{params[:recipe]['prep_time(5i)']}"
    # cook_time = "#{params[:recipe]['cook_time(4i)']}:#{params[:recipe]['cook_time(5i)']}"

    #<ActionController::Parameters {"utf8"=>"✓", "authenticity_token"=>"/+FjklqoosMjaDIoGRjtT1ym+7ZjZXf/2DRq0Ga+r+EedhpQmpl6QMwp6ZcBOryvFSsDW5/UU+XhQarSo5G/7A==", "recipe"=>{"name"=>"New", "description"=>"afdafd", "yield"=>"Serves", "yield_size"=>"6", "category_ids"=>["", "1", "2", "8", "23", "26", "32"], "prep_time(4i)"=>"00", "prep_time(5i)"=>"00", "cook_time(4i)"=>"00", "cook_time(5i)"=>"00", "private"=>"1"}, "commit"=>"Create", "controller"=>"recipes", "action"=>"create"} permitted: false>
    @recipes = Recipe.new(recipe_params)
    if @recipe.save
      redirect_to recipe_url(@recipe)
    else
      render :new
    end
  end

  def new
    @recipe = Recipe.new
    #@categories = Category.group_by_type
    @categories = Category.by_type
    @ingredients = Ingredient.all
    @measurements = Measurement.all
    @recipe.categories.build(category_type: "meal")
    @recipe.categories.build(category_type: "cuisine")
    @recipe.categories.build(category_type: "dish")
    @recipe.instructions.build
    @recipe.ingredients.build
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
        :url_image,
        :categories_ids => [],
        :categories_attributes => [:category_type, :name],
        :ingredients_attributes => [:name, :quantity, :measurement_id],
        :instructions_attributes => [:id, :description, :_destroy]
      )
    end
end
