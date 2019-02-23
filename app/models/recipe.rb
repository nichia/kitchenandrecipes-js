class Recipe < ApplicationRecord
  paginates_per 15

  has_one_attached :image
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :recipe_categories, dependent: :destroy
  has_many :categories, through: :recipe_categories
  has_many :recipe_ingredients, dependent: :destroy, inverse_of: :recipe # inverse_of use by cocoon gem
  has_many :ingredients, through: :recipe_ingredients, class_name: 'Ingredient' # class_name use by cocoon gem
  has_many :measurements, through: :recipe_ingredients
  has_many :instructions, dependent: :destroy, inverse_of: :recipe # inverse_of use by cocoon gem

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :yields, presence: true
  validates :yields_size, presence: true
  validate :image_validation

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  scope :public_recipes, -> { where("private = ?", false).order("id DESC") }
  scope :public_or_user_recipes, -> (uid) { where("private = ? or (private = ? and user_id = ?)", false, true, uid).order("id DESC") }
  #scope :private_and_user_recipes, -> (uid) { where("private = ? and user_id = ?", true, uid) }
  # returns Array instead of ActiveRecord_Relation, so not chainable
  #scope :public_or_user_recipes, -> (uid) { public_recipes + private_and_user_recipes(uid) }
  # .or not working
  #scope :public_or_user_recipes, -> (uid) { public_recipes.or(private_and_user_recipes(uid)) }

  scope :search_recipes, -> (name) { public_recipes.where("lower(name) LIKE ?", "%#{name.downcase}%").order("name ASC") }

  def self.search_recipes_by_ingredients(name)
    @ingredients = Ingredient.search_ingredients(name).to_a
    @recipes = Recipe.none
    @ingredients.each do |ingredient|
      @recipes += ingredient.recipes
    end
    binding.pry
    @recipes
  end

# Class method to query public recipes or public plus current users recipes
  def self.public_and_current_user_recipes(curr_user = nil)
    if curr_user
      self.public_or_user_recipes(curr_user)
    else
      self.public_recipes
    end
  end
  
  #accepts_nested_attributes_for :categories
  def categories_attributes=(categories_attributes)
    categories_attributes.values.each do |category_attributes|
      # Do not create a category if it's not named
      if category_attributes[:name].present?
        category = Category.find_or_create_by(category_type: category_attributes[:category_type], name: category_attributes[:name])
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
  
  def recipe_cloner(curr_user)
    time = Time.new
    
    copy = self.dup
    copy.user = curr_user
    copy.source = self.id
    copy.name = "#{self.name} #{copy.user_id} #{time.strftime("%Y%m%d%H%M%S")}"
    ActiveStorage::Downloader.new(self.image).download_blob_to_tempfile do |tempfile|
      copy.image.attach({
        io: tempfile,
        filename: self.image.blob.filename,
        content_type: self.image.blob.content_type
      })
    end
    
    if copy.save
      # copy the recipe_categories
      self.recipe_categories.find_each do |c|
        copy.recipe_categories << c.dup
      end
      # copy the recipe_ingredients
      self.recipe_ingredients.find_each do |c|
        copy.recipe_ingredients << c.dup
      end
      # copy the instructions
      self.instructions.find_each do |i|
        copy.instructions << i.dup
      end
    end
    copy
  end

  # Calculate average rating for the recipe instance
  def rating_average
    self.reviews.average(:rating).round(2)
  end
  
  private
  def image_validation
    if image.attached?
      if !image.content_type.in?(['image/gif', 'image/png', 'image/jpg', 'image/jpeg'])
        errors.add(:image, 'must be an image file with gif, jpeg, jpg or png format')
      end
    else
      errors.add(:image, 'must be added')
    end
  end

end
