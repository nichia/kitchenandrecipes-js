# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Lorem.unique.clear
Faker::Food.unique.clear
Faker::Internet.unique.clear

# Create Categories
def create_categories
  puts "create_categories..." 
  Category.create(category_type: 'meal', name: 'breakfast')
  Category.create(category_type: 'meal', name: 'entree')
  Category.create(category_type: 'meal', name: 'dessert')
  Category.create(category_type: 'meal', name: 'beverage')
  Category.create(category_type: 'meal', name: 'side')
  Category.create(category_type: 'meal', name: 'snack')
  Category.create(category_type: 'meal', name: 'salad')
  Category.create(category_type: 'meal', name: 'soup')
  Category.create(category_type: 'meal', name: 'appetizer')
end

# Create users
def create_users
  puts "create_users..."
  avatars = Dir.glob('storage/avatars/*.*')
  icon = avatars.sample
  User.create(
    name: "lorem",
    email: "lorem@email.com",
    password: "Password1!",
    first_name: "Lorem",
    last_name: "Ipsum"
  ) do |user|
    Rails.root.join(icon).open('rb') do |io|
      user.avatar.attach(io: io, filename: icon.split(/\//).last, content_type: ['image/jpg'])
    end
  end
  print ">"
     
  icon = avatars.sample
  User.create(
    name: "CDion",
    email: Faker::Internet.safe_email("celine.dion"),
    password: "#{Faker::Internet.password(8)}A1@",
    provider: "facebook",
    first_name: "Celine",
    last_name: "Dion",
    uid: Faker::Number.between(100000, 1000000)
  ) do |user|
    Rails.root.join(icon).open('rb') do |io|
      user.avatar.attach(io: io, filename: icon.split(/\//).last, content_type: ['image/jpg'])
    end
  end
  print ">"  

  10.times do
    icon = avatars.sample
    User.create(
      name: Faker::Internet.username(8, %w(. _)),
      email: Faker::Internet.unique.safe_email,
      password: "#{Faker::Internet.password(8)}A1@",
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name
    ) do |user|
      Rails.root.join(icon).open('rb') do |io|
        user.avatar.attach(io: io, filename: icon.split(/\//).last, content_type: ['image/jpg'])
      end
    end
    print ">"
  end
  puts "."
end

# Create Measurement
def create_measurement
  puts "create_measurement..."
  Measurement.create(unit: 'cup')
  Measurement.create(unit: 'teaspoon')
  Measurement.create(unit: 'tablespoon')
  Measurement.create(unit: 'bunch')
  Measurement.create(unit: 'cake')
  Measurement.create(unit: 'dash')
  Measurement.create(unit: 'drop')
  Measurement.create(unit: 'gallon')
  Measurement.create(unit: 'gram')
  Measurement.create(unit: 'handful')
  Measurement.create(unit: 'litre')
  Measurement.create(unit: 'ounce')
  Measurement.create(unit: 'packet')
  Measurement.create(unit: 'piece')
  Measurement.create(unit: 'pinch')
  Measurement.create(unit: 'pint')
  Measurement.create(unit: 'pond')
  Measurement.create(unit: 'quart')
  Measurement.create(unit: 'shot')
  Measurement.create(unit: 'splash')
  Measurement.create(unit: 'sprig')
end

# Create Ingredients
def create_ingredients
  puts "create_ingredients..."
  200.times do
    Ingredient.create(name: Faker::Food.unique.ingredient.downcase)
    print ">"
  end
  puts "."
end

# Create Recipes
def create_recipes
  puts "create_recipes..."
  yields = ['makes', 'serves']
  preps = ['cut', 'slice', 'shred', 'squeeze', 'chopped', 'grate', 'minced']
  images = Dir.glob('storage/images/*.*')

  100.times do
    icon = images.sample
    recipe = Recipe.create(
      name: "#{Faker::Food.dish.downcase} #{Faker::Lorem.unique.word}",
      description: Faker::Food.description,
      prep_time: Faker::Time.between(DateTime.now - 2, DateTime.now),
      cook_time: Faker::Time.between(DateTime.now - 2, DateTime.now),
      yields: yields.sample,
      yields_size: Faker::Coffee.blend_name,
      user: User.find_by_id(Faker::Number.between(1, 12))
    ) do |r|
      Rails.root.join(icon).open('rb') do |io|
        r.image.attach(io: io, filename: icon.split(/\//).last, content_type: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg'])
      end
    end

    recipe.recipe_categories.create(
      category: Category.find_by_id(Faker::Number.between(1, 9))
    )
  
    5.times do
      item = Ingredient.find_by_id(Faker::Number.between(1, 200))
      recipe.recipe_ingredients.create(
        quantity: Faker::Food.measurement,
        measurement: Measurement.find_by_id(Faker::Number.between(1, 22)),
        ingredient: item,
        description: "#{preps.sample} #{item.name}"
      )
    end
    
    6.times do
      recipe.instructions.create(description: Faker::Lorem.paragraph)
    end

    print ">"
  end
  puts "."
end

create_categories
create_ingredients
create_measurement
create_users
create_recipes