// users.js

// $(document).ready(function() {
$(function () {
  console.log('JS jQuery loaded Current User..');
  // $.get('/current_user', function (response) {  
  // debugger;
  // Fire ajax
  var current_user;
  $.ajax({
    method: "GET",
    url: '/current_user',
  }).done(function (response) {
    console.log('User name response: ', response);
    current_user = response;
  });
})