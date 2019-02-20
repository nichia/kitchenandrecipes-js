class IngredientSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name

  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
end
