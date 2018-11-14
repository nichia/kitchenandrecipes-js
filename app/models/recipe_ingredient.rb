class RecipeIngredient < ApplicationRecord
  belongs_to :measurement
  belongs_to :recipe
  belongs_to :ingredient
end
