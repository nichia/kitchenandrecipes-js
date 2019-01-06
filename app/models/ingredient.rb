class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, inverse_of: :ingredient
  has_many :recipes, through: :recipe_ingredients

  validates :name, uniqueness: { case_sensitive: false }

end
