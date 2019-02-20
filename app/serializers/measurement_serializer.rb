class MeasurementSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer
  
  attributes :id, :unit
  
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
end
