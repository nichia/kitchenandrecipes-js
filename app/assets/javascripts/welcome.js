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

function loadCurrentUser() {
  return new Promise(resolve => {
    // Fire ajax to get current_user
    console.log('loadCurrentUser: ', current_user)
    $.ajax({
      method: "GET",
      url: '/current_user',
      dataType: 'json'
    }).done(function (response) {
      // alert( "success" );
      console.log('CurrentUser response: ', response);
      current_user = new User(response);
    }).fail(function () {
      // alert( "error" );
      console.log('error');
      current_user = false;
    }).always(function () {
      resolve(current_user);
    });
  });
}