// recipes.js

class Recipe {
  constructor(obj) {
    // debugger;
    this.id = obj.id;
    this.name = obj.name;
    this.description = obj.description;
    this.prep_time = obj.prep_time;
    this.cook_time = obj.cook_time;
    this.yields = obj.yields;
    this.yields_size = obj.yields_size;
    this.image = obj.image;
    this.private = obj.private;
    this.category_id = obj.recipe_categories[0]["category"]["id"];
    this.category_name = obj.recipe_categories[0]["category"]["name"];
    this.image = obj.image;
    this.created_at = (new Date(obj.created_at)).toShortFormat();
    this.user_id = obj.user_id;
    this.user = obj.user;
    this.recipe_ingredients = obj.recipe_ingredients;
    this.instructions = obj.instructions;
    this.reviews = obj.reviews;
    this.reviews.forEach(function (review) {
      review.created_date = (new Date(review.created_at)).toShortFormat();
    });
  };
}

Recipe.prototype.recipeHtml = function(current_user) {
  // debugger;
  console.log("current_user class: ", current_user);
  // Invoke handlebar templates for recipes_show
  recipesShowHtml = HandlebarsTemplates["recipes/show"]({
    recipe: this,
    current_user: current_user
  });

  return recipesShowHtml;
};

// Attaching a new function toShortFormat() to any instance of Date() class
Date.prototype.toShortFormat = function () {
  var month_names = ["Jan", "Feb", "Mar",
    "Apr", "May", "Jun",
    "Jul", "Aug", "Sep",
    "Oct", "Nov", "Dec"];

  var day = this.getDate();
  var month_index = this.getMonth();
  var year = this.getFullYear();

  return "" + month_names[month_index] + " " + day + ", " + year;
}

//===== listenForClickIndexRecipes =====//

function listenForClickIndexRecipes() {
  console.log('listForClickIndexRecipes..');
  // Listen for click on link element with class index_recipes
  $(".index_recipes").on("click", function (event) {
    event.preventDefault();
    // debugger;
    loadRecipes(this);
  });
}

function loadRecipes(thisObj) {
  // Fire ajax to get Index of Recipes
  // debugger;
  if (typeof thisObj === "object") {
    thisUrl = thisObj.href;
  } else {
    thisUrl = thisObj;
  };
  $.ajax({
    method: "GET",
    url: thisUrl,
    dataType: 'json'
  }).done(function (response, textStatus, jqXHR) {
    console.log('AllRecipes response: ', response, 'textStatus:', textStatus, ' Header: ', jqXHR);
    let paginationData = {
      perPage: jqXHR.getResponseHeader('per-page'),
      total: jqXHR.getResponseHeader('total'),
      links: jqXHR.getResponseHeader('link')
    }
    let pagination = new Pagination(response.meta, paginationData)
    console.log('pagination data: ', pagination)
    // debugger;
    // Invoke handlebar templates for recipes_index
    recipesIndexHtml = HandlebarsTemplates['recipes/index']({
      recipes: response.recipes, pagination: pagination, current_user: current_user, isMainIndex: ($(this).parent().prevObject[0].url.includes("/api/recipes"))
    });
    // Load the recipesIndexHtml into the DOM (add it to the current page)
    $("#ajax-container").html(recipesIndexHtml);
    listenForClickMainLinks();
  });
}

//===== listenForClickPagination =====//

function listenForClickPagination() {
  console.log('listForClickPagination..');
  // Listen for click on link element with class index_recipes
  $('#next, #prev, #first, #last').on("click", function (event) {
    event.preventDefault();
    clearMessages();
    loadRecipes(this);
  });
}

//===== listenForClickShowRecipe =====//

function listenForClickShowRecipe() {
  console.log('listForClickShowRecipe..');
  // Listen for click on link with class show_recipe
  $(".show_recipe").on("click", function (event) {
    event.preventDefault();
    clearMessages();
   // debugger;
    // for images, access via this.parentElement.href
    let thisUrl = this.href || this.parentElement.href
    // let thisUrl = this.attributes.href || this.parentElement.attributes.href  *does not work
    // let thisUrl = this.attributes.href.textContent
    // Fire ajax to get Show Recipe data
    $.ajax({
      method: "GET",
      url: thisUrl,
      dataType: 'json'
    }).done(function (response) {
      console.log('ShowRecipe response: ', response);
      // debugger
      let recipe = new Recipe(response)
      // alert( "complete");
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipe.recipeHtml(current_user))
      listenForClickAfterShowRecipe();
    });
  });
}

//===== listenForClickAddRecipe =====//

function listenForClickAddRecipe() {
  console.log('listForClickAddRecipe..');
  // Listen for click on link element with class add_recipe
  $(".add_recipe").on("click", function (event) {
    event.preventDefault();
    clearMessages();
    // Fire ajax to get new recipe form
    // let url = this.href + "?no_layout=false";
    let thisUrl = this.attributes.href.textContent + "?no_layout=false";
    // debugger;
    $.ajax({
      method: "GET",
      url: thisUrl
    }).always(function (response) {
      console.log('AddRecipe response: ', response);
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(response);

      // Invoke handlebar templates for displaying links
      linksHtml = HandlebarsTemplates['recipes/links']({current_user: current_user});
      // Load the linksHtml into the DOM (add it #ajax-links tag)
      $("#ajax-links").html(linksHtml);

      listenForClickSubmitNewRecipe();
    });
  });
}

function listenForClickSubmitNewRecipe() {
  console.log('listForClickSubmitRecipe..');
  // debugger;
  // Listen for click on submit wtih id new_recipe
  $("#new_recipe").on("submit", function (event) {
    event.preventDefault();
    // let formData = $(this).serialize();   // submit data only, not files
    let formData = new FormData($(this)[0]); // submit data & files in one form
    let thisUrl = this.action + "?no_layout=false";
    // Fire ajax to post new recipe form
    // debugger;
    $.ajax({
      method: "POST",
      url: thisUrl,
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false,
      cache: false,
    }).done(function (response, textStatus, jqXHR) {
      console.log('Done NewRecipe response: ', response, 'textStatus:', textStatus, ' Header: ', jqXHR);
      const customMessage = `<h3>Recipe successfully created.</h3>`;
      // Load the response into the DOM (add it to the current page)
      $(".flash-message").html(customMessage);
      // debugger;
      let recipe = new Recipe(response)
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(recipe.recipeHtml(current_user))
      listenForClickAfterShowRecipe();
    }).fail(function (response, textStatus, jqXHR) {
    // }).fail(function (jqXHR, textStatus, err) {
      console.log('Fail NewRecipe response: ', response, 'textStatus:', textStatus, ' Header: ', jqXHR);
      const customMessage = `<h3>Error adding recipe: ${response.responseJSON.error}</h3>`;
      // Load the response into the DOM (add it to the current page)
      $(".flash-message").html(customMessage);
      // debugger;
      $(".btn.btn-primary").prop("disabled", false);  // enable the Create Recipe button
    });
  });
}

//===== listenForClickCloneRecipe =====//

function listenForClickCloneRecipe() {
  console.log('listForClickCloneRecipe..');
  // Listen for click on click wtih id clone_recipe
  $("#clone_recipe").on("click", function (event) {
    event.preventDefault();
    var choice = confirm("Are you sure you want to clone this recipe?");
    if (choice) {
      let thisUrl = this.attributes.href.textContent + "?no_layout=false"; 
      const authenticity_token = $('meta[name="csrf-token"]').attr("content");
      // debugger;
      // Fire ajax to clone recipe
      $.ajax({
        method: "POST",
        url: thisUrl,
        headers: {
          "X-CSRF-Token": authenticity_token,
          "Content-Type": "application/json"
        },
      }).done(function (response, textStatus, jqXHR) {
        console.log('Done CloneRecipe response: ', response, 'textStatus:', textStatus, ' Header: ', jqXHR);
        const customMessage = `<h3>Recipe successfully cloned.</h3>`;
        // Load the response into the DOM (add it to the current page)
        $(".flash-message").html(customMessage);
        // debugger;
        let recipe = new Recipe(response)
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(recipe.recipeHtml(current_user))
        listenForClickAfterShowRecipe();
      }).fail(function (response, textStatus, jqXHR) {
        console.log('Fail CloneRecipe response: ', response, 'textStatus:', textStatus, ' Header: ', jqXHR);
        const customMessage = `<h3>${response.responseJSON.error}</h3>`;
        // Load the response into the DOM (add it to the current page)
        $(".flash-message").html(customMessage);
        debugger;
      });
    };
  });
}

//===== listenForClickDeleteRecipe =====//

function listenForClickDeleteRecipe() {
  console.log('listForClickDeleteRecipe..');
  // Listen for click on link element with id delete_recipe and data-confirm 
  $("#delete_recipe").on("click", function (event) {
    event.preventDefault();
    clearMessages();
    // Fire ajax to delete recipe
    // note: this.href === event.target.href (includes baseURI of http://localhost:3000)
    // debugger;
    var choice = confirm("Are you sure you want to delete this recipe?");
    if (choice) {
      let thisUrl = this.attributes.href.textContent + "?no_layout=false"; // $(this).attr('href')
      const authenticity_token = $('meta[name="csrf-token"]').attr("content"); // fix the 422 unprocessable entity error
      $.ajax({
        method: "DELETE",
        // beforeSend: function (xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')) },
        url: thisUrl,
        headers: {
          "X-CSRF-Token": authenticity_token,
          "Content-Type": "application/json"
        },
      }).fail(function (response, textStatus, jqXHR) {
          console.log("Error response: ", response);
          const customMessage = `<h3>Error deleting recipe.</h3>`;
          // Load the response into the DOM (add it to the current page)
          $(".flash-message").html(customMessage);
          loadRecipes("/api/recipes");
      }).done(function(response, textStatus, jqXHR) {
        // Load the response into the DOM (add it to the current page)
        console.log(
          "AllRecipes response: ",
          response,
          " Header: ",
          jqXHR
        );
        const customMessage = `<h3>Sucessfully deleted recipe</h3>`;
        // Load the response into the DOM (add it to the current page)
        $(".flash-message").html(customMessage);
        loadRecipes(`/api/users/${current_user.id}/recipes`);
      });
    };
  });
}

//===== listenForClickAddReview =====//

function listenForClickAddReview() {
  console.log('listForClickAddReview..');
  // Listen for click on button with id add_review
  $("#add_review").on("click", function (event) {
    event.preventDefault();
    clearMessages();
    // debugger;
    // Fire ajax to get new review form
    // let thisUrl = this.href + "?no_layout=false";
    let thisUrl = this.attributes.href.textContent + "?no_layout=false";
    $.ajax({
      method: "GET",
      url: thisUrl
    }).always(function (response) {
      console.log('AddReview response: ', response);
      // Load the response into the DOM (add it to the current page)
      $("#ajax-container").html(response);
      listenForClickSubmitNewReview();
    });
  });
}

function listenForClickSubmitNewReview() {
  console.log('listForClickSubmitReview..');
  // debugger;
  // Listen for click on submit wtih id new_review
  $("#new_review").on("submit", function (event) {
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
      dataType: 'json',
      success: response => {
        let recipe = new Recipe(response)
        // debugger;
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(recipe.recipeHtml(current_user))
        listenForClickMainLinks();
      },
      error: response => {
        const customMessage = `<h3>Error adding review.</h3>`
        // debugger;
        // Load the response into the DOM (add it to the current page)
        $("#ajax-container").html(customMessage);
      }
    });
  });
}

function listenForClickMainLinks() {
  listenForClickIndexRecipes();
  listenForClickAddRecipe();
  listenForClickShowRecipe();
  listenForClickPagination();     
}

function listenForClickAfterShowRecipe() {
  listenForClickIndexRecipes();
  listenForClickAddRecipe();
  // listenForClickEditRecipe();
  listenForClickCloneRecipe();
  listenForClickDeleteRecipe();
  listenForClickAddReview();
}