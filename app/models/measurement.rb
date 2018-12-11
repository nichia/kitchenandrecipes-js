class Measurement < ApplicationRecord
  has_many :recipe_ingredients, inverse_of: :measurement
  has_many :recipes, through: :recipe_ingredients

end
