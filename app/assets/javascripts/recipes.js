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
    this.user_id = obj.user_id;
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

  console.log('current_user class: ', current_user);

  // Invoke handlebar templates for recipes_show
  recipesShowHtml = HandlebarsTemplates['recipes/show']({
    recipe: this, current_user: current_user
  });

  return recipesShowHtml;
}

//==================================//

function listenForClickIndexRecipes() {
  console.log('listForClickIndexRecipes..');
  // Listen for click on link element with class index_recipes
  $(".index_recipes").on("click", function (event) {
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
        recipes: response, isAllIndex: ($(this).parent().prevObject[0].url.endsWith("/api/recipes"))
      });
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipesIndexHtml);

      listenForClickShowRecipe();
      listenForClickIndexRecipes();
    });
  });
}
    
function listenForClickShowRecipe() {
  console.log('listForClickShowRecipe..');
  // Listen for click on link with class show_recipe
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
        console.log('CurrentUser response: ', response);
        current_user = new User(response)
      }).always(function() {
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(recipe.recipeHtml(current_user))
        listenForClickIndexRecipes();
        listenForClickAddReview();
      });
    });
  });
}

function listenForClickAddReview() {
  console.log('listForClickAddReview..');
  // Listen for click on link element with id add_review
  $("#add_review").on("click", function (event) {
    event.preventDefault();
    // debugger;
    // Fire ajax to get new review form
    // let url = this.attributes.÷href.textContent + "?layout=false";
    let url = this.href + "?layout=false";
    $.ajax({
      method: "GET",
      url: url
    }).always(function (response) {
      console.log('AddReview response: ', response);
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(response);
      listenForClickSubmitNewReview();
    });
  });
}

function listenForClickSubmitNewReview() {
  console.log('listForClickSubmitReview..');
  // debugger;
  // Listen for click on submit wtih new_review class
  $("#new_review").on("submit", function (event) {
    event.preventDefault();
    let data = $(this).serialize();
    let url = this.action;
    // debugger;
    // Fire ajax to post new review form
    $.ajax({
      method: "POST",
      url: url,
      data: data,
      dataType: 'json',
      success: response => {
        let recipe = new Recipe(response)
        // debugger;
        // Fire ajax to get current_user
        $.ajax({
          method: "GET",
          url: '/current_user',
        }).done(function (response) {
          console.log('CurrentUser response: ', response);
          current_user = new User(response)
        }).always(function () {
          // Load the response into the DOM (add it to the current page)
          $("#ajax-container").html(recipe.recipeHtml(current_user))
          listenForClickIndexRecipes();
          listentForClickAddReview();
        });
      },
      error: response => {
        const customMessage = `<h3>Error adding review.</h3>`
        // debugger;
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(customMessage);
      }
    });
  });
}