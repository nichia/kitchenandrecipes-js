// reviews.js

//===== listenForClickAddReview =====//

function listenForClickAddReview() {
  console.log("listForClickAddReview..");
  // Listen for click on button with id add_review
  $("#add_review").on("click", function(event) {
    event.preventDefault();
    clearMessages();
    // debugger;
    // Fire ajax to get new review form
    // let thisUrl = this.href + "?no_layout=false";
    let thisUrl = this.attributes.href.textContent + "?no_layout=false";
    $.ajax({
      method: "GET",
      url: thisUrl
    }).always(function(response) {
      console.log("AddReview response: ", response);
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(response);
      listenForClickSubmitNewReview();
    });
  });
}

function listenForClickSubmitNewReview() {
  console.log("listForClickSubmitReview..");
  // debugger;
  // Listen for click on submit wtih id new_review
  $("#new_review").on("submit", function(event) {
    event.preventDefault();
    clearMessages();
    let formData = $(this).serialize();
    let thisUrl = this.action + "?no_layout=false";
    // debugger;
    // Fire ajax to post new review form
    $.ajax({
      method: "POST",
      url: thisUrl,
      data: formData,
      dataType: "json",
      success: response => {
        let recipe = new Recipe(response);
        // debugger;
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(recipe.recipeHtml(current_user));
        listenForClickAfterShowRecipe();
      },
      error: response => {
        const customMessage = `<h3>Error adding review.</h3>`;
        // debugger;
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(customMessage);
      }
    });
  });
}

//===== listenForClickEditReview =====//

function listenForClickEditReview() {
  console.log("listForClickEditReview..");
  // Listen for click on button with id edit_review
  $("#edit_review").on("click", function (event) {
    event.preventDefault();
    clearMessages();
    debugger;
    let thisUrl = this.attributes.href.textContent + "?no_layout=false";
    $.ajax({
      method: "GET",
      url: thisUrl
    }).always(function (response) {
      console.log("AddReview response: ", response);
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(response);
      listenForClickSubmitNewReview();
    });
  });
}



//===== listenForClickDeleteReview =====//

function listenForClickDeleteReview() {
  console.log("listForClickDeleteReview..");
  // Listen for click on button with id delete_review
  $("#delete_review").on("click", function (event) {
    event.preventDefault();
    clearMessages();
    debugger;
    let thisUrl = this.attributes.href.textContent + "?no_layout=false";
    $.ajax({
      method: "DELETE",
      beforeSend: function (xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')) },
      url: thisUrl
    }).always(function (response, textStatus, jqXHR) {
      console.log('DeleteReview  response: ', response, 'textStatus:', textStatus, ' Header: ', jqXHR);
    // let thisUrl = this.href + "?no_layout=false";
      const customMessage = `<h3>Review successfully deleted</h3>`;
      // Load the response into the DOM (add it to the current page)
      $(".flash-message").html(customMessage);
      let recipe = new Recipe(response);
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipe.recipeHtml(current_user));
        listenForClickAfterShowRecipe();
    });
  });
}
