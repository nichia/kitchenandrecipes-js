# Rails App with JavaScript Frontend Spec Assessment
Project Specs:
- [] Must have a Rails Backend and new requirements implemented through JavaScript.
- [] Makes use of ES6 features as much as possible(e.g Arrow functions, Let & Const, Constructor Functions)
- [] Must translate the JSON responses into Javascript Model Objects using either ES6 class or constructor syntax. 
- [] Must render at least one index page (index resource - 'list of things') via JavaScript and an Active Model Serialization JSON Backend.
- [] Must render at least one show page (show resource - 'one specific thing') via JavaScript and an Active Model Serialization JSON Backend.
- [] Your Rails application must reveal at least one `has-many` relationship through JSON that is then rendered to the page.
- [] Must use your Rails application to render a form for creating a resource that is submitted dynamically through JavaScript.
- [] At least one of the JS Model Objects must have a method on the prototype.

Project Repo Specs:
Read Me file contains:
- [] Application Description
- [] Installation guide (e.g. fork and clone repo, migrate db, bundle install, etc)
- [] Contributors guide (e.g. file an issue, file an issue with a pull request, etc)
- [] Licensing statement at the bottom (e.g. This project has been licensed under the MIT open source license.)

Repo General
- [] You have a large number of small Git commits
- [] Your commit messages are meaningful
- [] You made the changes in a commit that relate to the commit message
- [] You don't include changes in a commit that aren't related to the commit message

# Specifications for the Rails Assessment

Specs:
- [x] Using Ruby on Rails for the project
- [x] Include at least one has_many relationship (x has_many y; e.g. User has_many Recipes)
- [x] Include at least one belongs_to relationship (x belongs_to y; e.g. Recipe belongs_to User)
- [x] Include at least two has_many through relationships (x has_many y through z; e.g. Recipe has_many Ingredients through Recipe_ingredients)
- [x] Include at least one many-to-many relationship (x has_many y through z, y has_many x through z; e.g. Recipe has_many Ingredients through Recipe_ingredients, Ingredient has_many Recipes through Recipe_ingredients)
- [x] The "through" part of the has_many through includes at least one user submittable attribute, that is to say, some attribute other than its foreign keys that can be submitted by the app's user (attribute_name e.g. Recipe_ingredients.quantity, Recipe_ingredients.description)
- [x] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient)
- [x] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. Recipe.search_recipes URL: /search)
- [x] Include signup (how e.g. Devise)
- [x] Include login (how e.g. Devise)
- [x] Include logout (how e.g. Devise)
- [x] Include third party signup/login (how e.g. Devise/OmniAuth Facebook, Google and Twitter)
- [x] Include nested resource show or index (URL e.g. users/2/recipes)
- [x] Include nested resource "new" form (URL e.g. users/1/recipes/new)
- [x] Include form display of validation errors (form URL e.g. /recipes/new)

Confirm:
- [x] The application is pretty DRY
- [x] Limited logic in controllers
- [x] Views use helper methods if appropriate
- [x] Views use partials if appropriate
