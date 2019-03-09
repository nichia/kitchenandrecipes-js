// users.js

function getCurrentUser() {
  console.log('getCurrentUser...');
  // debugger;
  // Fire ajax
  $.ajax({
    method: "GET",
    url: '/current_user',
  }).done(function (current_user) {
    console.log('Current user: ', current_user);
    return current_user
  });
}