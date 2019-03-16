// welcome.js

$(document).on('turbolinks:load', function () {
  console.log('JS Turbolinks loaded..')
  clearMessages();
  listenForClickIndexRecipes();
  listenForClickAddRecipe();
})

// $(document).ready(function() {
$(function () {
  console.log('JS jQuery loaded..');
})

function clearMessages() {
  $('.flash-message').removeClass('.flash-message')
}