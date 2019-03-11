// recipes.js

class Recipe {
  constructor(obj) {
    // debugger;
    this.id = obj.id;
    this.name = obj.name;
    this.description = obj.description;
    this.prep_time = obj.prep_time;
    this.cook_time = obj.cook_time;
    this.yields = obj.yields;
    this.yields_size = obj.yields_size;
    this.image = obj.image;
    this.private = obj.private;
    this.category_id = obj.recipe_categories[0]["category"]["id"];
    this.category_name = obj.recipe_categories[0]["category"]["name"];
    this.image = obj.image;
    this.created_at = obj.created_at;
    this.user = obj.user;
    this.recipe_ingredients = obj.recipe_ingredients;
    // merge three array of objects (recipe_ingredients, ingredients and measurements) *** fixed with include option for serializing deeply nested associations ***
    // this.recipe_ingredients = obj.recipe_ingredients.map((recipe_ingredient) => {
    //   var haveEqualIngredientId = (ingredient) => ingredient.id === recipe_ingredient.ingredient_id
    //   var haveEqualMeasurementId = (measurement) => measurement.id === recipe_ingredient.measurement_id
    //   var ingredientWithEqualId = obj.ingredients.find(haveEqualIngredientId)
    //   var measurementWithEqualId = obj.measurements.find(haveEqualMeasurementId)

    //   return Object.assign({}, recipe_ingredient, ingredientWithEqualId, measurementWithEqualId)
    // });
    this.instructions = obj.instructions;
    this.reviews = obj.reviews;
  };
}

Recipe.prototype.recipeHtml = function (current_user) {
  // debugger;

  console.log('XXuser: ', current_user);

  // Invoke handlebar templates for recipes_show
  recipesShowHtml = HandlebarsTemplates['recipes/show']({
    recipe: this, current_user: current_user
  });

  return recipesShowHtml;
}

//==================================//

function listenForClickRecipes() {
  console.log('listForClickRecipes..');
  // Listen for click on link element with class all_recipes and my_recipes
  $("a.all_recipes, a.my_recipes").on("click", function (event) {
    event.preventDefault();
    // debugger;
    // Fire ajax to get Index of Recipes
    $.ajax({
      method: "GET",
      url: this.href,
      dataType: 'json'
    }).done(function (response) {
      console.log('AllRecipes response: ', response);
      // Invoke handlebar templates for recipes_index
      recipesIndexHtml = HandlebarsTemplates['recipes/index']({
        recipes: response
      });
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipesIndexHtml);

      listenForClickShowRecipe();
      listenForClickRecipes();
    });
  });
}
    
function listenForClickShowRecipe() {
  console.log('listForClickShowRecipe..');
  // Listen for click on link with class my_recipes
  let current_user = false
  $(".show_recipe").on("click", function (event) {
    event.preventDefault();
    var thisUrl = this.href || this.parentElement.href
    // debugger;
    // Fire ajax to get Show Recipe data
    $.ajax({
      method: "GET",
      url: thisUrl,
      dataType: 'json'
    }).done(function (response) {
      console.log('ShowRecipe response: ', response);
      let recipe = new Recipe(response)
      // Fire ajax to get current_user
      $.ajax({
        method: "GET",
        url: '/current_user',
      }).done(function (response) {
        console.log('Current user: ', response);
        current_user = new User(response)
      }).always(function() {
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(recipe.recipeHtml(current_user))
      });
    });
  });
}
