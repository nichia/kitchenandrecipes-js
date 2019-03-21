// welcome.js

// Global variable current_user signed-in
let current_user = false

$(document).on('turbolinks:load', function () {
  console.log('JS Turbolinks loaded..')
  // Single Page Application when accessing via root route "/"
  if (window.location.pathname === "/") {
    clearMessages();
    asyncCall();
  };
})

// $(document).ready(function() {
// Not always loaded... not sure yet under what condition this gets loaded
$(function () {
  console.log('JS jQuery loaded..');
})

function clearMessages() {
  $(".flash-message").removeClass(".flash-message").html("");
}

async function asyncCall() {
  console.log('calling');
  var result = await loadCurrentUser();
  console.log('result', result);
  loadRecipes("/api/recipes");
}
