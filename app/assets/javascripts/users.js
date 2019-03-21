// users.js

class User {
  constructor(obj) {
    // debugger;
    this.id = obj.id;
    this.email = obj.email;
    this.name = obj.name;
    this.avatar = obj.avatar;
  };
}

//===== loadCurrentUser =====//

function loadCurrentUser() {
  return new Promise(resolve => {
    // Fire ajax to get current_user
    console.log("loadCurrentUser: ", current_user);
    $.ajax({
      method: "GET",
      url: "/current_user",
      dataType: "json"
    })
      .done(function(response) {
        // alert( "success" );
        console.log("CurrentUser response: ", response);
        current_user = new User(response);
      })
      .fail(function() {
        // alert( "error" );
        console.log("error");
        current_user = false;
      })
      .always(function() {
        resolve(current_user);
      });
  });
}