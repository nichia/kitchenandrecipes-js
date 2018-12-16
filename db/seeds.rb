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
Category.create(category_type: 'Meal', name: 'appetizer')
Category.create(category_type: 'Meal', name: 'breakfast')
Category.create(category_type: 'Meal', name: 'entree')
Category.create(category_type: 'Meal', name: 'dessert')
Category.create(category_type: 'Meal', name: 'beverage')
Category.create(category_type: 'Meal', name: 'side')
Category.create(category_type: 'Cusine', name: 'asian')
Category.create(category_type: 'Cusine', name: 'chinese')
Category.create(category_type: 'Cusine', name: 'vietnamese')
Category.create(category_type: 'Cusine', name: 'japanese')
Category.create(category_type: 'Cusine', name: 'korean')
Category.create(category_type: 'Cusine', name: 'malaysian')
Category.create(category_type: 'Cusine', name: 'indian')
Category.create(category_type: 'Cusine', name: 'western')
Category.create(category_type: 'Cusine', name: 'african')
Category.create(category_type: 'Cusine', name: 'american')
Category.create(category_type: 'Cusine', name: 'french')
Category.create(category_type: 'Cusine', name: 'greek')
Category.create(category_type: 'Cusine', name: 'irish')
Category.create(category_type: 'Cusine', name: 'italian')
Category.create(category_type: 'Cusine', name: 'mexican')
Category.create(category_type: 'Cusine', name: 'middle eastern')
Category.create(category_type: 'Dish', name: 'bread')
Category.create(category_type: 'Dish', name: 'cake')
Category.create(category_type: 'Dish', name: 'pasta')
Category.create(category_type: 'Dish', name: 'soup')
Category.create(category_type: 'Dish', name: 'stew')
Category.create(category_type: 'Dish', name: 'pizza')
Category.create(category_type: 'Dish', name: 'pie')
Category.create(category_type: 'Dish', name: 'salad')
Category.create(category_type: 'Dish', name: 'sandwich')
Category.create(category_type: 'Dish', name: 'roast')


# Create users
avatars = Dir.glob('storage/avatars/*.jpg')

user = User.create(
  name: "lorem",
  email: "lorem@email.com",
  password: "Password1!",
  first_name: "Lorem",
  last_name: "Ipsum"
)
icon = avatars.sample
user.avatar.attach(io: File.open(icon), filename: icon.split(/\//).last, content_type: ['image/png', 'image/jpg', 'image/jpeg'])

user = User.create(
  name: "CDion",
  email: Faker::Internet.safe_email("celine.dion"),
  password: "#{Faker::Internet.password(8)}A1@",
  provider: "facebook",
  first_name: "Celine",
  last_name: "Dion",
  uid: Faker::Number.between(100000, 1000000)
)
icon = avatars.sample
user.avatar.attach(io: File.open(icon), filename: icon.split(/\//).last, content_type: ['image/png', 'image/jpg', 'image/jpeg'])

10.times do
  user = User.create(
    name: Faker::Internet.username(8, %w(. _)),
    email: Faker::Internet.unique.safe_email,
    password: "#{Faker::Internet.password(8)}A1@",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
  )
  icon = avatars.sample
  user.avatar.attach(io: File.open(icon), filename: icon.split(/\//).last, content_type: ['image/png', 'image/jpg', 'image/jpeg'])
end

# Measurement
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

# Create Ingredients
200.times do
  Ingredient.create(name: Faker::Food.unique.ingredient.downcase)
end

# Create Recipes
yields = ['makes', 'serves']
preps = ['cut', 'slice', 'shred', 'squeeze', 'chopped', 'grate', 'minced']
images = Dir.glob('storage/images/*.jpg')
100.times do
  recipe = Recipe.create(
    name: "#{Faker::Food.dish.downcase} #{Faker::Lorem.unique.word}",
    description: Faker::Food.description,
    prep_time: Faker::Coffee.intensifier,
    cook_time: Faker::Coffee.intensifier,
    yield: yields.sample,
    yield_size: Faker::Coffee.blend_name,
    url_image: Faker::LoremPixel.image("50x60"),
    user: User.find_by_id(Faker::Number.between(1, 12))
  )
  icon = images.sample
  recipe.image.attach(io: File.open(icon), filename: icon.split(/\//).last, content_type: ['image/png', 'image/jpg', 'image/jpeg'])

  recipe.recipe_categories.create(
    category: Category.find_by_id(Faker::Number.between(1, 6))
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
end
