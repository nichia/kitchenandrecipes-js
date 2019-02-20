class RecipeCategorySerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer
  
  attributes :id, :recipe_id, :category_id
  
  belongs_to :recipe
  belongs_to :category
end
