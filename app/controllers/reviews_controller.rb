class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :set_recipe, only: [:new, :edit, :update, :create]

  # GET /recipes/:recipe_id/reviews/new
  def new
    @review = Review.new
    if params[:layout] && params[:layout] == "false"
      render :new, layout: false
    else
      render :new
    end
  end
  
  # GET /recipes/:recipe_id/reviews/:id/edit
  def edit
    # binding.pry
  end
  
  # POST /recipes/:recipe_id/reviews
  def create
    # binding.pry
    @review = current_user.reviews.new(review_params)
    @review.recipe = @recipe
    if @review.save
      # redirect_to recipe_path(@review.recipe)
      render json: @recipe, include: ['user', 'reviews', 'reviews.reviewer', 'recipe_categories', 'recipe_categories.category', 'recipe_ingredients', 'recipe_ingredients.ingredient', 'recipe_ingredients.measurement', 'instructions'], status: 201
    else
      flash.now[:danger] = "Error adding review. Please try again"
      render :new
    end
  end
  
  # PATCH /recipes/:recipe_id/reviews/:id
  def update
    # binding.pry
    if @review.update(review_params)
      redirect_to @review.recipe
    else
      flash.now[:danger] = "Error updating review. Please try again"
      render :edit
    end
  end
  
  # DELETE /recipes/:recipe_id/reviews/:id
  def destroy
    # binding.pry
    @review.destroy
    flash[:info] = "Review successfully deleted"
    redirect_to recipe_path(@review.recipe)
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
