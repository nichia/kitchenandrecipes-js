class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :create_copy]
  before_action :set_select_collections, only: [:edit, :update, :new, :create]
  before_action :check_permission, only: [:edit, :update, :destroy]

  # GET /recipes
  # GET /users/:user_id/recipes
  def index
    if params[:user_id]
      # Dropdown option 'My Recipe' navbar avatar
      user = User.find(params[:user_id])
      @recipes = user.recipes.page(params[:page])
    else
      # navbar Kitchen&Recipes button
      @recipes = Recipe.public_and_current_user_recipes(current_user).page(params[:page])
    end
    # respond_to do |format|
    #   format.html { render :index }
    #   # format.json { render json: @recipes }
    #   format.json { render json: @recipes, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions']}
    # end
  end

  # GET /users/:user_id/recipes/new
  def new
    @recipe = Recipe.new
    set_recipe_nested_forms
    render :new, layout: (params[:no_layout] ? false : true)
  end

  # GET /recipes/:id
  # GET /users/:user_id/recipes/:id
  def show
    if @recipe.private
      check_permission
    end
    @recipe_ingredients = @recipe.recipe_ingredients
    @instructions = @recipe.instructions
    @reviews = @recipe.reviews.page(params[:page])
    # respond_to do |format|
    #   format.html { render :show }
    #   # format.json { render json: @recipe }
    #   format.json { render json: @recipe, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions']}
    # end
  end

  # GET /users/:user_id/recipes/:id/edit
  def edit
    render :edit, layout: (params[:no_layout] ? false : true)
  end

  # GET /search
  def search
    if params[:recipe_name]
      @recipe_name = params[:recipe_name]
      @recipes = Recipe.search_recipes(params[:recipe_name]).page(params[:page])
    elsif params[:ingredient_name]
      @ingredient_name = params[:ingredient_name]
      @recipes = Recipe.search_recipes_by_ingredients(params[:ingredient_name]).page(params[:page])
    else
      redirect_back(fallback_location: root_path)
    end
  end

  # POST /recipes/:id/copy
  def create_copy
    #raise params.inspect
    copy = @recipe.recipe_cloner(current_user)
    if copy
      if params[:no_layout]
        # binding.pry
        render json: copy, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions'], status: 201
      else
        flash[:info] = "Recipe successfully cloned"
        redirect_to user_recipe_path(current_user, copy)
      end
    else
      flash[:danger] ="Error cloning recipe! Please try again."
      if params[:no_layout]
        # binding.pry
        render json: { error: flash[:danger] }, status: 409
      else
        redirect_to recipe_path(@recipe)
      end
    end
  end

  # POST /users/:user_id/recipes
  def create
    # raise params.inspect
    # binding.pry
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      if params[:no_layout]
        # binding.pry
        render json: @recipe, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions'], status: 201
      else
        flash[:info] = "Recipe successfully created"
        redirect_to user_recipe_path(current_user, @recipe)
      end
    else
      # if errors with save action,
      # list error messages and go back to new view
      flash.now[:danger] = ("Please fix the following errors:<br/>".html_safe + @recipe.errors.full_messages.join("<br/>").html_safe)
      # re-populate the category field (removed: to be added for admin only)
      # category = params[:recipe][:categories_attributes].values[0]
      # @recipe.categories.build(category_type: category[:category_type], name: category[:name])
      if params[:no_layout]
        # binding.pry
        render json: { error: flash.now[:danger] }, status: 409
      else
        render :new
      end
    end
  end

  # PATCH /users/:user_id/recipes/:id
  def update
    #raise params.inspect
    if @recipe.update(recipe_params)
      if params[:no_layout]
        render json: @recipe, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions'], status: 201
      else
        flash[:info] = "Recipe successfuly updated"
        redirect_to user_recipe_path(current_user, @recipe)
      end
    else
      flash.now[:danger] = ("Please fix the following errors:<br/>".html_safe + @recipe.errors.full_messages.join("<br/>").html_safe)
      if params[:no_layout]
        render json: { error: flash.now[:danger] }, status: 409
      else
        render :edit
      end
    end
  end

 # DELETE /users/:user_id/recipes/:id
  def destroy
    deleted = @recipe.destroy
    if params[:no_layout]
      render json: deleted, status: 204
    else
      flash[:info] = "Recipe successfuly deleted!"
      redirect_to user_recipes_path(current_user)
    end
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
      @categories = Category.by_meal_type
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
        flash[:danger] = "You don't have permision to access this recipe"
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
end
