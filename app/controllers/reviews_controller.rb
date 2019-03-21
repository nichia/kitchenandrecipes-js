class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :set_recipe, only: [:new, :edit, :update, :create, :destroy]

  # GET /recipes/:recipe_id/reviews/new
  def new
    @review = Review.new
    render :new, layout: (params[:no_layout] ? false : true)
  end
  
  # GET /recipes/:recipe_id/reviews/:id/edit
  def edit
    # binding.pry
    render :edit, layout: (params[:no_layout] ? false : true)
  end
  
  # POST /recipes/:recipe_id/reviews
  def create
    # binding.pry
    @review = current_user.reviews.new(review_params)
    @review.recipe = @recipe
    if @review.save
      if params[:no_layout]
        render json: @recipe, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions'], status: 201
      else
        flash[:info] = "Review successfuly added"
        redirect_to recipe_path(@review.recipe)
      end
    else
      # binding.pry
      flash.now[:danger] = ("Please fix the following errors:<br/>".html_safe + @review.errors.full_messages.join("<br/>").html_safe)
      if params[:no_layout]
        render json: { error: flash.now[:danger] }, status: 409
      else
        render :new
      end
    end
  end
  
  # PATCH /recipes/:recipe_id/reviews/:id
  def update
    # binding.pry
    if @review.update(review_params)
      if params[:no_layout]
        render json: @recipe, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions'], status: 201
      else
        flash[:info] = "Review successfuly updated"
        redirect_to @review.recipe
      end
    else
      flash.now[:danger] = ("Please fix the following errors:<br/>".html_safe + @review.errors.full_messages.join("<br/>").html_safe)
      if params[:no_layout]
        render json: { error: flash.now[:danger] }, status: 409
      else
        render :edit
      end
    end
  end
  
  # DELETE /recipes/:recipe_id/reviews/:id
  def destroy
    # binding.pry
    @review.destroy
    if params[:no_layout]
      render json: @recipe, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions'], status: 201
    else
      flash[:info] = "Review successfully deleted"
      redirect_to recipe_path(@review.recipe)
    end
  end

  private
  
  def set_review
    @review = Review.find(params[:id])
  end

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :recipe_id)
  end
end
