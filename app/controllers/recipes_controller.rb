class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_select_collections, only: [:edit, :update, :new, :create]

 # GET /recipes
  def index
    @recipes = Recipe.public_recipes
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
    set_recipe_nested_forms
  end

  # GET /recipes/:id
  def show
    @recipe_ingredients = @recipe.recipe_ingredients
    @instructions = @recipe.instructions
  end

  # GET /recipes/:id/edit
  def edit
  end

  # POST /recipes
  def create
    #raise params.inspect
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    binding.pry
    if @recipe.valid?
      if @recipe.save
        flash[:message] = "Recipe successfully created"
        redirect_to recipe_url(@recipe) and return
      end
    end

    # if recipe is not valid or there're errors with recipe save,
    # list error messages and go back to new
    flash.now[:message] = ("Errors creating the recipe:<br/>".html_safe + @recipe.errors.full_messages.join("<br/>").html_safe)
    category = params[:recipe][:categories_attributes].values[0]
    @recipe.categories.build(category_type: category[:category_type], name: category[:name])
    render :new
  end

 # PATCH /recipes/:id
  def update
    raise params.inspect

  end

 # DELETE /recipes/:id
  def destroy
    raise params.inspect

  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def set_select_collections
      @categories = Category.by_type
      @ingredients = Ingredient.all
      @measurements = Measurement.all
    end

    def set_recipe_nested_forms
      @recipe.categories.build(category_type: "dish")
      @recipe.instructions.build
      @recipe.recipe_ingredients.build
    end

    def recipe_params
      params.require(:recipe).permit(
        :name,
        :description,
        :prep_time,
        :cook_time,
        :yield,
        :yield_size,
        :image,
        :private,
        :source,
        :category_ids,
        :categories_attributes => [:name, :category_type],
        :recipe_ingredients_attributes => [:id, :_destroy, :name, :quantity, :measurement_id, :ingredient_id, :description, ingredients: [:name]],
        :instructions_attributes => [:id, :_destroy, :description]
      )
    end
end
