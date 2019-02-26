$(document).on('turbolinks:load', function () {
  console.log('JS Turbolinks loaded..')
  listenForClickAllRecipes();
  listenForClickMyRecipes();
})

// $(document).ready(function() {
$(function () {
  console.log('JS jQuery loaded..');
})

function listenForClickAllRecipes() {
  console.log('listForClickAllRecipes..');
  // let doc = document.getElementById('all-recipes');
  // doc.addEventListener('click', function (event) {
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
      // Get a response
      let htmlResp = getRecipes(response);

      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(htmlResp);
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
      // Get a response
      let htmlResp = getRecipes(response);

      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(htmlResp);
    });
  });
}
    
function getRecipes(data) {
  let recipes = data;
  let recipeObj = "";
  
  // <p class="text-center card-text"><small class="text-muted"><%= pluralize(recipes.total_count, 'Recipe') %></small></p>
  
  let htmlResp = `
    <div class="container-fluids">
    <p class="text-center card-text"><small class="text-muted">101 Recipes</small></p>
    <div class="card-columns">
  `;  // Open div tags
  recipes.forEach((recipe) => {
    // htmlResp += '<li>' + recipe["name"] + '</li>';
    // recipeObj = new Recipe(recipe);
    // htmlResp += recipeObj.recipeHTML();
    // htmlResp += `<li> ${recipe["name"]} </li>`
    htmlResp += getRecipesHtml(recipe);
  });
  htmlResp += `</div></div>`; // Close div tags
  
  return htmlResp;
}
    
function getRecipesHtml(recipe) {
  return (`
    <div class="card" >
      <a href="/recipes/${recipe["id"]}"><img class="card-img-top" src="${recipe["image"]}"></a>
      <div class="card-body">
          <p class="card-text"><small class="text-muted">by <a href="/users/${recipe["user_id"]}">${recipe.user["name"]}</a></small></p>
          <h4 class="card-title"><a href="/recipes/${recipe["id"]}">${recipe["name"]}</a></h4>
          <p class="card-text">${recipe["description"]}</p>
        </div>
    </div>
  `);
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
  `)
}
