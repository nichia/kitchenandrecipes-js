// recipes.js

$(document).on('turbolinks:load', function () {
  console.log('JS Turbolinks loaded..')
  listenForClickRecipes();
})

// $(document).ready(function() {
$(function () {
  console.log('JS jQuery loaded..');
})

function listenForClickRecipes() {
  console.log('listForClickRecipes..');
  // Listen for click on link element with class all_recipes and my_recipes
  $("a.all_recipes, a.my_recipes").on("click", function (event) {
    event.preventDefault();
    // debugger;
    // Fire ajax
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
  $(".show_recipe").on("click", function (event) {
    event.preventDefault();
    var thisUrl = this.href || this.parentElement.href
    // debugger;
    // Fire ajax
    $.ajax({
      method: "GET",
      url: thisUrl,
      dataType: 'json'
    }).done(function (response) {
      console.log('ShowRecipe response: ', response);
      let recipe = new Recipe(response)
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipe.recipeHtml())
    });
  });
}

class Recipe {
  constructor(obj) {
    // debugger
    this.id = obj.id;
    this.name = obj.name;
    this.description = obj.description;
    this.prep_time = obj.prep_time;
    this.cook_time = obj.cook_time;
    this.yields = obj.yields;
    this.yields_size = obj.yields_size;
    this.image = obj.image;
    this.private = obj.private;
    this.category_name = obj.categories[0]["name"];
    this.image = obj.image;
    this.created_at = obj.created_at;
    this.recipe_ingredients = obj.recipe_ingredients;
    this.instructions = obj.instructions;
    this.reviews = obj.reviews;
  };
}

Recipe.prototype.recipeHtml = function () {
  // debugger;
  var reviews = this.reviews.map(review => {
    return `<li> ${review.rating} ^* ${review.comment} ^* ${review.user_id} </li>`;
  });

  var ingredients = this.recipe_ingredients.map(ingredient => {
    return `<li> ${ingredient.description} * ${ingredient.quantity} </li>`;
  });

  var instructions = this.instructions.map(instruction => {
    return `<li> ${instruction.description} </li>`;
  });

  return (`
    <li> ${this.id} | ${this.name} | ${this.category_name} | </li>
    <li>${this.id} |
    ${this.name} |
    ${this.description} | </li>
    <li>${this.prep_time} |
    ${this.cook_time} | </li>
    <li>${this.yields} | 
    ${this.yields_size} |</li>
    <li>${this.image} | </li>
    <li>${this.private} |
    ${this.category_name} | 
    ${this.created_at} |</li>
    ${ingredients} | 
    ${instructions} |  
    ${reviews} 
  `);

  // Invoke handlebar templates for recipes_show
  // recipesShowHtml = HandlebarsTemplates['recipes/show']({
  //   recipe: this
  // });

  return recipesShowHtml;
}
