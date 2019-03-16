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
    // merge three array of objects (recipe_ingredients, ingredients and measurements) 
    // *** fixed with include option for serializing deeply nested associations ***
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

//===== listenForClickIndexRecipes =====//

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
    // }).done(function (response) {
    }).done(function (response, textStatus, jqXHR) {
      console.log('AllRecipes response: ', response, ' Header: ', jqXHR);
      let paginationData = {
        perPage: jqXHR.getResponseHeader('per-page'),
        total: jqXHR.getResponseHeader('total'),
        links: jqXHR.getResponseHeader('link')
      }
      let pagination = new Pagination(response.meta, paginationData)
      console.log('pagination data: ', pagination)
      // debugger;
      // Invoke handlebar templates for recipes_index
      recipesIndexHtml = HandlebarsTemplates['recipes/index']({
        recipes: response.recipes, pagination: pagination, isMainIndex: ($(this).parent().prevObject[0].url.includes("/api/recipes"))
      });
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipesIndexHtml);

      listenForClickShowRecipe();
      listenForClickIndexRecipes();
      listenForClickPagination();
    });
  });
}

//===== listenForClickPagination =====//

function listenForClickPagination() {
  console.log('listForClickPagination..');
  // Listen for click on link element with class index_recipes
  $('#next, #prev, #first, #last').on("click", function (event) {
    event.preventDefault();
    // Fire ajax to get Index of Recipes
    $.ajax({
      method: "GET",
      url: this.href,
      dataType: 'json'
      // }).done(function (response) {
    }).done(function (response, textStatus, jqXHR) {
      console.log('AllRecipes response: ', response, ' Header: ', jqXHR);
      let paginationData = {
        perPage: jqXHR.getResponseHeader('per-page'),
        total: jqXHR.getResponseHeader('total'),
        links: jqXHR.getResponseHeader('link')
      }
      let pagination = new Pagination(response.meta, paginationData)
      console.log('pagination data: ', pagination)
      // Invoke handlebar templates for recipes_index
      recipesIndexHtml = HandlebarsTemplates['recipes/index']({
        recipes: response.recipes, pagination: pagination, isMainIndex: ($(this).parent().prevObject[0].url.includes("/api/recipes"))
      });
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipesIndexHtml);

      listenForClickShowRecipe();
      listenForClickIndexRecipes();
      listenForClickPagination();
    });
  });
}

//===== listenForClickShowRecipe =====//

function listenForClickShowRecipe() {
  console.log('listForClickShowRecipe..');
  // Listen for click on link with class show_recipe
  $(".show_recipe").on("click", function (event) {
    event.preventDefault();
    // debugger;
    // for images, access via this.parentElement.href
    let thisUrl = this.href || this.parentElement.href
    // let thisUrl = this.attributes.href || this.parentElement.attributes.href  *does not work
    // let thisUrl = this.attributes.href.textContent
    // Fire ajax to get Show Recipe data
    $.ajax({
      method: "GET",
      url: thisUrl,
      dataType: 'json'
    }).done(function (response) {
      console.log('ShowRecipe response: ', response);
      let recipe = new Recipe(response)
      // alert( "complete");
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipe.recipeHtml(current_user))
      listenForClickIndexRecipes();
      listenForClickDeleteRecipe();
      listenForClickAddReview();
    });
  });
}

//===== listenForClickAddRecipe =====//

function listenForClickAddRecipe() {
  console.log('listForClickAddRecipe..');
  // Listen for click on link element with class add_recipe
  $(".add_recipe").on("click", function (event) {
    event.preventDefault();
    // Fire ajax to get new recipe form
    // let url = this.href + "?no_layout=false";
    let thisUrl = this.attributes.href.textContent + "?no_layout=false";
    // debugger;
    $.ajax({
      method: "GET",
      url: thisUrl
    }).always(function (response) {
      console.log('AddRecipe response: ', response);
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(response);
      listenForClickSubmitNewRecipe();
    });
  });
}

function listenForClickSubmitNewRecipe() {
  console.log('listForClickSubmitRecipe..');
  // debugger;
  // Listen for click on submit wtih id new_recipe
  $("#new_recipe").on("submit", function (event) {
    event.preventDefault();
    // let formData = $(this).serialize();   // submit data only, not files
    let formData = new FormData($(this)[0]); // submit data & files in one form
    let thisUrl = this.action + "?no_layout=false";
    // Fire ajax to post new recipe form
    $.ajax({
      method: "POST",
      url: thisUrl,
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false,
      cache: false,
      success: response => {
        let recipe = new Recipe(response)
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(recipe.recipeHtml(current_user))
        listenForClickIndexRecipes();
      },
      error: response => {
        const customMessage = `<h3>Error adding recipe.</h3>`
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(customMessage);
      }
    });
  });
}

//===== listenForClickDeleteRecipe =====//

function listenForClickDeleteRecipe() {
  console.log('listForClickDeleteRecipe..');
  // Listen for click on link element with id delete_recipe
  $("#delete_recipe").on("click", function (event) {
    event.preventDefault();
    // debugger;
    // Fire ajax to delete recipe
    // note: this.href === event.target.href (includes baseURI of http://localhost:3000)
    let thisUrl = "/api" + this.attributes.href.textContent;
    $.ajax({
      method: "DELETE",
      url: thisUrl,
      // success: response => {
      //   console.log('DeleteRecipe response: ', response);
      //   // Load the response into the DOM (add it to the current page)
      //   $("#ajax-container").html(response);
      //   listenForClickShowRecipe();
      //   listenForClickIndexRecipes();      
      // },
      error: response => {
        console.log('Error response: ', response);
        const customMessage = `<h3>Error deleting recipe.</h3>`
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(customMessage);
      }
    }).always(function (response) {
      console.log('AfterDelete response: ', response);
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(response);
      listenForClickShowRecipe();
      listenForClickIndexRecipes();      
    });
  });
}

//===== listenForClickAddReview =====//

function listenForClickAddReview() {
  console.log('listForClickAddReview..');
  // Listen for click on button with id add_review
  $("#add_review").on("click", function (event) {
    event.preventDefault();
    // debugger;
    // Fire ajax to get new review form
    // let thisUrl = this.href + "?no_layout=false";
    let thisUrl = this.attributes.href.textContent + "?no_layout=false";
    $.ajax({
      method: "GET",
      url: thisUrl
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
  // Listen for click on submit wtih id new_review
  $("#new_review").on("submit", function (event) {
    event.preventDefault();
    let formData = $(this).serialize();
    let thisUrl = this.action + "?no_layout=false";
    // debugger;
    // Fire ajax to post new review form
    $.ajax({
      method: "POST",
      url: thisUrl,
      data: formData,
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