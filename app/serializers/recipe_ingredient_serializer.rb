class RecipeIngredientSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer
  
  attributes :id, :measurement_id, :recipe_id, :ingredient_id, :quantity, :description

  belongs_to :measurement
  belongs_to :recipe
  belongs_to :ingredient
end
