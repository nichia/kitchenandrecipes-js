class CategorySerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name

  has_many :recipe_categories
  has_many :recipes, through: :recipe_categories
end
