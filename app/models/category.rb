class Category < ApplicationRecord
  has_many :recipe_categories
  has_many :recipes, through: :recipe_categories

  #scope :by_type, -> { order(category_type: :asc, name: :asc) }
  #scope :by_type, -> { select(:id, :category_type, :name).group_by{ |c| c.category_type } }
  scope :by_type, -> { select(:id, :category_type, :name).order(category_type: :asc, name: :asc) }

  scope :group_by_type, -> { by_type.group_by { |c| c.category_type }}

  def name_with_type
    "#{category_type}: #{name}"
  end
end
