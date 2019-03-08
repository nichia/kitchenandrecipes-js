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