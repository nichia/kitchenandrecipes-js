// users.js

function loadRecipeActions() {
  console.log('loadRecipeActions...');
  // debugger;
  // Fire ajax
  $.ajax({
    method: "GET",
    url: '/current_user',
  }).done(function (current_user) {
    console.log('Current user: ', current_user);
  });
}