class RecipeSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :user_id, :name, :description, :prep_time, :cook_time, :yields, :yields_size, :image, :private, :source, :created_at

  belongs_to :user
  has_many :reviews
  has_many :recipe_categories
  has_many :categories, through: :recipe_categories
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :measurements, through: :recipe_ingredients
  has_many :instructions

  def image
    rails_blob_path(object.image, only_path: true) if object.image.attached?
  end
end
