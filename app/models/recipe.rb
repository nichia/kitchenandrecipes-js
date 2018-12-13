class Recipe < ApplicationRecord
  has_one_attached :image
  
  belongs_to :user
  has_many :reviews
  has_many :recipe_categories
  has_many :categories, through: :recipe_categories
  has_many :recipe_ingredients, inverse_of: :recipe
  has_many :ingredients, through: :recipe_ingredients, class_name: 'Ingredient'
  has_many :measurements, through: :recipe_ingredients
  has_many :instructions, inverse_of: :recipe

  validates :name, presence: true

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  scope :public_recipes, -> { where(private: false) }

  #accepts_nested_attributes_for :categories
  def categories_attributes=(categories_attributes)
    categories_attributes.values.each do |category_attributes|
      # Do not create a category if it's not named
      if category_attributes[:name].present?
        category = Category.find_or_create_by(category_type: categoriy_attributes[:category_type], name: category_attributes[:name])
        self.recipe_categories.build(category: category)
      end
    end
  end

  accepts_nested_attributes_for :recipe_ingredients, reject_if: :all_blank, allow_destroy: true
  # def ingredients_attributes=(ingredients_attributes)
  #   ingredients_attributes.values.each do |ingredient_attributes|
  #     if ingredient_attributes[:name].present?
  #       ingredient = Ingredient.find_or_create_by(name: ingredient_attributes[:name])
  #       measurement = Measurement.find_by(id: ingredient_attributes[:measurement_id])
  #       self.recipe_ingredients.build(quantity: ingredient_attributes[:quantity], ingredient: ingredient, measurement: measurement)
  #     end
  #   end
  # end

  accepts_nested_attributes_for :instructions, reject_if: :all_blank, allow_destroy: true
  # def instructions_attributes=(instructions_attributes)
  #   instructions_attributes.values.each do |instruction_attributes|
  #     self.instructions.build(description: description)
  #   end
  # end

end
