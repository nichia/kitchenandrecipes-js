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

      // Invoke handlebar templates for displaying links (to list recipes)
      linksHtml = HandlebarsTemplates['recipes/links']({ current_user: current_user });
      // Load the linksHtml into the DOM (add it #ajax-links tag)
      $("#ajax-links").html(linksHtml);

      listenForClickSubmitNewReview();
      listenForClickAfterShowRecipe();
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
    }).done(function (response, textStatus, jqXHR) {
      console.log('Done NewReview response: ', response, 'textStatus:', textStatus, ' Header: ', jqXHR);
      const customMessage = `<h3>Review successfully created.</h3>`;
      // Load the response into the DOM (add it to the current page)
      $(".flash-message").html(customMessage);
      // debugger;
      let recipe = new Recipe(response)
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipe.recipeHtml(current_user))
      listenForClickAfterShowRecipe();
    }).fail(function (response, textStatus, jqXHR) {
      // }).fail(function (jqXHR, textStatus, err) {
      console.log('Fail NewReview response: ', response, 'textStatus:', textStatus, ' Header: ', jqXHR);
      const customMessage = `<h3>Error adding review. ${response.responseJSON.error}</h3>`;
      // Load the response into the DOM (add it to the current page)
      $(".flash-message").html(customMessage);
      // debugger;
      $(".btn.btn-primary").prop("disabled", false);  // enable the Create Review button
    });
  });
}

//===== listenForClickUpdateReview =====//

function listenForClickUpdateReview() {
  console.log("listForClickEditReview..");
  // Listen for click on link element with id update_review
  $("#update_review").on("click", function(event) {
    event.preventDefault();
    clearMessages();
    // Fire ajax to get edit review form
    let thisUrl = this.attributes.href.textContent + "?no_layout=false";
    $.ajax({
      method: "GET",
      url: thisUrl
    }).always(function(response) {
      console.log("UpdateReview response: ", response);
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(response);

      // Invoke handlebar templates for displaying links (to list recipes)
      linksHtml = HandlebarsTemplates['recipes/links']({ current_user: current_user });
      // Load the linksHtml into the DOM (add it #ajax-links tag)
      $("#ajax-links").html(linksHtml);

      listenForClickSubmitUpdateReview();
      listenForClickAfterShowRecipe();
    });
  });
}

function listenForClickSubmitUpdateReview() {
  console.log("listForClickSubmitUpdateReview..");
  // debugger;
  // Listen for click on submit wtih class edit_review
  $(".edit_review").on("submit", function (event) {
    event.preventDefault();
    clearMessages();
    let formData = $(this).serialize();
    let thisUrl = this.action + "?no_layout=false";
    // debugger;
    // Fire ajax to post updated review form
    $.ajax({
      method: "PATCH",
      url: thisUrl,
      data: formData,
      dataType: "json",
    }).done(function (response, textStatus, jqXHR) {
      console.log('Done UpdateReview response: ', response, 'textStatus:', textStatus, ' Header: ', jqXHR);
      const customMessage = `<h3>Review successfully updated.</h3>`;
      // Load the response into the DOM (add it to the current page)
      $(".flash-message").html(customMessage);
      let recipe = new Recipe(response)
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipe.recipeHtml(current_user))
      listenForClickAfterShowRecipe();
    }).fail(function (response, textStatus, jqXHR) {
      // }).fail(function (jqXHR, textStatus, err) {
      console.log('Fail UpdateReview response: ', response, 'textStatus:', textStatus, ' Header: ', jqXHR);
      const customMessage = `<h3>Error updating review. ${response.responseJSON.error}</h3>`;
      // Load the response into the DOM (add it to the current page)
      $(".flash-message").html(customMessage);
      $(".btn.btn-primary").prop("disabled", false);  // enable the Update Review button
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
    // debugger;
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
