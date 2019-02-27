$(document).on('turbolinks:load', function () {
  console.log('JS Turbolinks loaded..')
  listenForClickAllRecipes();
  listenForClickMyRecipes();
})

// $(document).ready(function() {
// $(function () {
//   console.log('JS jQuery loaded..');
// })

function listenForClickAllRecipes() {
  console.log('listForClickAllRecipes..');
  // Listen for click on link with class all_recipes
  $("a.all_recipes").on("click", function (event) {
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
    });
  });
}

function listenForClickMyRecipes() {
  console.log('listForClickMyRecipes..');
  // Listen for click on link with class my_recipes
  $("a.my_recipes").on("click", function (event) {
    event.preventDefault();
    // Fire ajax
    $.ajax({
      method: "GET",
      url: this.href,
      dataType: 'json'
    }).done(function (response) {
      console.log('MyRecipes response: ', response);
      // Invoke handlebar templates for recipes_index
      recipesIndexHtml = HandlebarsTemplates['recipes/index']({
        recipes: response
      });
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipesIndexHtml);
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
    this.recipe_ingredients = obj.recipe_ingredients;
    this.instructions = obj.instructions;
  }
}

Recipe.prototype.recipeHTML = function () {
  return (`
    <li> ${this.id} | ${this.name} | ${this.category_name} </li>
  `);
}
