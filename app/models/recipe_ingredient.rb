class RecipeIngredient < ApplicationRecord
  belongs_to :measurement, optional: true
  belongs_to :recipe
  belongs_to :ingredient

  scope :ordered_recipe_ingredients, -> { order("id ASC") }

  # cocoon gem passes via params ingredients instead of ingredient_attributes
  #accepts_nested_attributes_for :ingredient, reject_if: :all_blank
  def ingredients=(ingredient_attributes)
    if ingredient_attributes[:name].present?
      self.ingredient = Ingredient.where(name: ingredient_attributes[:name]).first_or_create
    end
  end

end
