$(document).on('turbolinks:load', function () {
  console.log('index.js Turbolinks loaded..')
  listenForClickAllRecipes();
})

// $(document).ready(function() {
  $(function () {
    console.log('index.js jQuery loaded..');
})


function listenForClickAllRecipes() {
  let doc = document.getElementById('all-recipes');

  doc.addEventListener('click', function (event) {
    event.preventDefault();
    getAllRecipes();
  });
}

function getAllRecipes() {
  console.log('--> getAllRecipes')
  $.ajax({
    type: "get",
    url: "/recipes",
    method: "get",
    dataType: 'json'
  }).done(function (response) {
    console.log('response: ', response);
    // debugger;
    let recipes = response;
    let recipeObj = "";
    let recipeString = "";
    recipes.forEach((recipe) => {
      // recipeString += '<li>' + recipe["name"] + '</li>';
      recipeObj = new Recipe(recipe);
      recipeString += recipeObj.recipeHTML()
    });
    $("#ajax-container").html(recipeString)
  });
}

class Recipe {
  constructor(obj) {
    this.id = obj.id;
    this.name = obj.name;
    this.description = obj.description;
    this.prep_time = obj.prep_time;
    this.cook_time = obj.cook_time;
    this.yields = obj.yields;
    this.yields_size = obj.yields_size;
    this.image = obj.image;
    this.private = obj.private;
  }
}

Recipe.prototype.recipeHTML = function () {
  return (`
    <li> ${this.id} ${this.name} ${this.description} </li>
  `)
}
