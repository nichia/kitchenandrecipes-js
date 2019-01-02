class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :create_copy]
  before_action :set_select_collections, only: [:edit, :update, :new, :create]
  before_action :check_permission, only: [:edit, :update, :destroy]

 # GET /recipes
  def index
    if params[:user_id]
      if user = User.find_by(id: params[:user_id])
        @recipes = user.recipes
      else
        flash[:danger] = "User not found"
        redirect_to root_path
      end
    else
      @recipes = Recipe.public_recipes
    end
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

  # POST /recipes/copy
  def create_copy
    copy = @recipe.recipe_cloner(current_user)
    redirect_to recipe_path(copy)
  end

  # POST /recipes
  def create
    #raise params.inspect
    @recipe = current_user.recipes.new(recipe_params)

    if @recipe.valid?
      if @recipe.save
        flash[:info] = "Recipe successfully created"
        redirect_to recipe_path(@recipe) and return
      end
    end

    # if recipe is not valid or errors with save action,
    # list error messages and go back to new view
    flash.now[:danger] = ("Please fix the following errors:<br/>".html_safe + @recipe.errors.full_messages.join("<br/>").html_safe)

    # re-populate the category field
    category = params[:recipe][:categories_attributes].values[0]
    @recipe.categories.build(category_type: category[:category_type], name: category[:name])

    render :new
  end

 # PATCH /recipes/:id
  def update
    #raise params.inspect
    if @recipe.update(recipe_params)
      flash[:info] = "Recipe successfuly updated"
      redirect_to user_recipe_path(current_user, @recipe)
    else
      # if recipe is not valid or errors with update action,
      # list error messages and go back to new
      flash.now[:danger] = ("Please fix the following errors:<br/>".html_safe + @recipe.errors.full_messages.join("<br/>").html_safe)

      # re-populate the category field
      category = params[:recipe][:categories_attributes].values[0]
      @recipe.categories.build(category_type: category[:category_type], name: category[:name])

      render :edit
    end
  end

 # DELETE /recipes/:id
  def destroy
    @recipe.destroy
    flash[:info] = "Recipe successfuly deleted!"
    redirect_to user_recipes_path(current_user)
  end

  private
    def set_recipe
      @recipe = Recipe.find_by(id: params[:id])
      if @recipe == nil
        flash[:danger] = "This recipe #{params[:id]} does not exist"
        redirect_to root_path
      end
    end

    def set_select_collections
      @categories = Category.by_type
      @ingredients = Ingredient.all
      @measurements = Measurement.all
    end

    def set_recipe_nested_forms
      # moved this line to form view so edit action will display a blank input field instead of the existing category name
      # @recipe.categories.build(category_type: "meal")
      @recipe.instructions.build
      @recipe.recipe_ingredients.build
    end

    def check_permission
      if @recipe.user != current_user
        flash[:danger] = "You don't have permision to do that"
        redirect_back(fallback_location: root_path)
      end
    end

    def recipe_params
      params.require(:recipe).permit(
        :name,
        :description,
        :prep_time,
        :cook_time,
        :yields,
        :yields_size,
        :image,
        :private,
        :source,
        :category_ids,
        :categories_attributes => [:name, :category_type],
        :recipe_ingredients_attributes => [:id, :_destroy, :name, :quantity, :measurement_id, :ingredient_id, :description, ingredients: [:name]],
        :instructions_attributes => [:id, :_destroy, :description]
      )
    end

    def recipe_copy_params
      # skip :id and :_destroy field from the hashes
      # recipe_ingredients_atributes and instructions_attributes
      params.require(:recipe).permit(
        :name,
        :description,
        :prep_time,
        :cook_time,
        :yields,
        :yields_size,
        :image,
        :private,
        :source,
        :category_ids,
        :categories_attributes => [:name, :category_type],
        :recipe_ingredients_attributes => [:name, :quantity, :measurement_id, :ingredient_id, :description, ingredients: [:name]],
        :instructions_attributes => [:description]
      )
    end
end
