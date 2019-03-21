// handlebars_helpers.js

Handlebars.registerHelper('titleCase', function (str) {
  str = str.toLowerCase().split(' ').map(function (word) {
    return (word.charAt(0).toUpperCase() + word.slice(1))
  })
  return str.join(' ');
});

Handlebars.registerHelper('pageButton', function (str) {
  // return str.capitalize();
  switch (str) {
    case 'first':
      return "« First";
    case 'prev':
      return "‹ Prev";
    case 'next':
      return "Next ›";
    case 'last':
      return "Last »";
    default:
      return str;
  }
});

// Attaching a new function capitalize() to any instance of String() class
String.prototype.capitalize = function () {
  return this.charAt(0).toUpperCase() + this.slice(1);
}

Handlebars.registerHelper('avgRating', function (recipe) {
  const reducer = (accumulator, currentvalue) => accumulator + currentvalue.rating;

  if (recipe.reviews.length > 0){
    return recipe.reviews.reduce(reducer, 0) / recipe.reviews.length;
  } else {
    return 0;
  }
});

Handlebars.registerHelper('addReviewButton', function (recipe, current_user) {
  if (recipe.reviews.find(e => e.user_id === current_user.id)) {
    // debugger;
    var html = ""
  } else {
    // debugger;
  var html = `<a id="add_review" class="btn btn-primary" href="/recipes/${recipe.id}/reviews/new">Add Review</a>`;
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