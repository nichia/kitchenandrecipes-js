// handlebars_helpers.js

Handlebars.registerHelper('addReviewButton', function (recipe, current_user) {
  if (recipe.reviews.find(e => e.user_id === current_user.id)) {
    debugger;
    var html = ""
  } else {
    debugger;
  var html = `<a class="btn btn-primary" href="/recipes/${recipe.id}/reviews/new">Add Review</a>`;
  }
  return html;
});

Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
  return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
});

Handlebars.registerHelper("counter", function (index) {
  return index + 1;
});

Handlebars.registerHelper("debug", function (optionalValue) {
  console.log("Current Context");
  console.log("====================");
  console.log(this);

  if (!optionalValue.hash && optionalValue) {
    console.log("Value");
    console.log("====================");
    console.log(optionalValue);
  }
});

Handlebars.registerHelper("consoleLog", function (optionalValue) {
  console.log(optionalValue);
});