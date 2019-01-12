class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, inverse_of: :ingredient
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :search_ingredients, -> (name) { where("lower(name) LIKE ?", "%#{name.downcase}%").order("name ASC") }

end
