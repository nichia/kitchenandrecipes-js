class Recipe < ApplicationRecord
  belongs_to :user
  has_many :reviews
  has_many :recipe_categories
  has_many :categories, through: :recipe_categories
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :instructions

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods
  
  scope :all_public, -> { where(private: false) }

end
