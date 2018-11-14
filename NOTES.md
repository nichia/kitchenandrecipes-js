# Homecooked
Homecooked is a ruby on rails application created to manage and share recipes.
The application uses Ruby on Rails framework and manages data through forms and RESTful routes. It provides standard user authentication, including signup, login, logout and passwords. In addition, the authentication system allows login from other third party services, Facebook, Google and Twitter.

The stretch goals are:
-	Write Tests for the project using RSPEC and Capybara
-	Host the application on Heroku platform

To Do:
- Design data models and associations
- Write user stories
- Sketch out rough screen layouts
- Setup the Homecooked application to use postgresql database. Do this now so it can easily be hosted on Heroku platform later
  - install and setup postgresql
- Generate models and migrations and setup Activerecord associations. Add Activerecord validations.
- Write RSPEC/Capybara Tests
- Start routes, controllers, and views for home page, signup, login and logout
- Implement authentication using Devise/OmniAuth
- Add edit and delete of User account.
- Setup seeds data for db
- Continue with main CRUD logic for recipes and it's corresponding routes, controller and views.
- Use Activerecord scope method and query methods for browsing recipes by different filters (eg. ingredient count, author, meal type, rating, etc)
- Refactor - DRY

## References
### Bootstrap setup

### Postgresql database setup
[Getting Started with PostgreSQL on Mac OSX](https://www.codementor.io/engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb)
[Setting up PostgreSQL with Rails Application](https://medium.com/@noordean/setting-up-postgresql-with-rails-application-357fe5e9c28)
### Authentication using Devise and omniauth
[Devise docs on getting started](https://github.com/plataformatec/devise)
[Devise docs on OmniAuth: Overview - setting up omniauth strategy using Facebook](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview)
[Devise docs on Controller filters and helpers](https://github.com/plataformatec/devise#controller-filters-and-helpers)
[Integrating Social Login in a Ruby on Rails Application using omniauth and Devise](https://scotch.io/tutorials/integrating-social-login-in-a-ruby-on-rails-application)
[How To Setup Devise and OmniAuth for Your Rails Application](https://www.adrianprieto.com/how-to-setup-devise-and-omniauth-for-your-rails-application/)
[Devise Authentication in Depth](https://www.sitepoint.com/devise-authentication-in-depth/)
[User Authentication in Rails with Devise](https://gorails.com/episodes/user-authentication-with-devise)
[Omniauth Docs on Auth Hash Schema](https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema)
[Facebook Omniauth Strategy](https://github.com/mkdynamic/omniauth-facebook)
[Github Omniauth Strategy](https://github.com/omniauth/omniauth-github)  
[Google Omniauth Strategy](https://github.com/zquestz/omniauth-google-oauth2)
