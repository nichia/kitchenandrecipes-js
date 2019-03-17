// welcome.js

// Global variable current_user signed-in
let current_user = false

$(document).on('turbolinks:load', function () {
  console.log('JS Turbolinks loaded..')
  clearMessages();
  asyncCall();
})

// $(document).ready(function() {
$(function () {
  console.log('JS jQuery loaded..');
})


function clearMessages() {
  $(".flash-message").removeClass(".flash-message");
}

async function asyncCall() {
  console.log('calling');
  var result = await loadCurrentUser();
  console.log('result', result);
  loadRecipes("/api/recipes");
  // listenForClickIndexRecipes();
  // listenForClickAddRecipe();
}

function loadCurrentUser() {
  return new Promise(resolve => {
    // Fire ajax to get current_user
    console.log('load cu: ', current_user)
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