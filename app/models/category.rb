class Category < ApplicationRecord
  has_many :recipe_categories
  has_many :recipes, through: :recipe_categories

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  scope :by_meal_type, -> { where(category_type: "meal").order(name: :asc) }

  # scope :by_type, -> { select(:id, :category_type, :name).order(category_type: :asc, name: :asc) }
  # scope :group_by_type, -> { by_type.group_by { |c| c.category_type }}

  # def name_with_type
  #   "#{category_type}: #{name}"
  # end
end
