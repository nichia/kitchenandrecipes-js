class RecipeCategorySerializer < ActiveModel::Serializer
  attributes :id, :recipe_id, :category_id
  
  belongs_to :recipe
  belongs_to :category
end
