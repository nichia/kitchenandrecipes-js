// welcome.js

$(document).on('turbolinks:load', function () {
  console.log('JS Turbolinks loaded..')
  listenForClickIndexRecipes();
  listenForClickAddRecipe();
})

// $(document).ready(function() {
$(function () {
  console.log('JS jQuery loaded..');
})

