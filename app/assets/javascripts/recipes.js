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
    debugger;
    let recipes = response;
    let recipeString = "";
    recipes["data"].forEach((recipe) => {
      recipeString += '<li>' + recipe["attributes"]["name"] + '</li>';
    });
    $("#ajax-container").html(recipeString)
  });
}
