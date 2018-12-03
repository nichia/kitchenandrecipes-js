# Models

## Devise Users
### Attributes
-	name
-	email
-	encrypted_password
- first_name
- last_name
- provider
- uid
- token
- secret
- image
- ## Recoverable
- ## Rememberable
- ## Trackable

### Associations
- has many recipes
- has many reviews

## recipes
### Attributes
- name
- description
- prep_time
- cook_time
- yield
- private
- source
- url_image
- user_id
### Associations
- belongs to user
- has many reviews
- has many recipe_categories
- has many categories through recipe_categories
- has many recipe_ingredients
- has many ingredients through recipe_ingredients
- has many instructions

## reviews
### Attributes
- rating
- comment
- user_id
- recipe_id
### Associations
- belongs to user
- belongs to recipe

## recipe_categories
### Attributes
- recipe_id
- category_id
### Associations
- belongs to recipe
- belongs to category

## categories
### Attributes
- category_type
- name
### Associations
- has many recipe_categories
- has many recipes through recipe_categories

## recipe_ingredients
### Attributes
- quantity
- measurement_id
- recipe_id
- ingredient_id
### Associations
- belongs to recipe
- belongs to ingredient
- belongs to measurement

## ingredients
### Attributes
- name
### Associations
- has many recipe_ingredients
- has many recipes through recipe_ingredients

## measurements
### Attributes
- unit
### Associations
- has many recipe_ingredients

## instructions
### Attributes
- description
### Associations
- belongs to recipe
