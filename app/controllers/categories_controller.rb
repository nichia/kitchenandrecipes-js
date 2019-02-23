class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  # GET /categories
  def index
    @categories = Category.by_meal_type
  end

  # GET /categories/:id
  def show
    @recipes = @category.recipes.public_and_current_user_recipes(current_user).page(params[:page])
  end

  private
    def set_category
      @category = Category.find_by(id: params[:id])
      if @category == nil
        flash[:danger] = "This category #{params[:id]} does not exist"
        redirect_to root_path
      end
    end
end
