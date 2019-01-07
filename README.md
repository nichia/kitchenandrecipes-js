# Kitchenandrecipes
Kitchenandrecipes is a ruby on rails application created to manage and share recipes.

## Installation to run locally
In a bash terminal, clone the application repository from github then run the application.

    $ git clone git@github.com:nichia/kitchenandrecipes.git
    $ cd kitchenandrecipes
    $ mv .env.bak .env  (edit the .env file to fill in secret keys)
    $ rvm --default use 2.5.0 (set default Ruby version 2.5.0)
    $ bundle install
    $ rake db:create
    $ rake db:migrate
    $ rake db:seed

## Run the server
In a bash terminal, run the server.

    $ rails s

## Usage
Open up a web browser and copy/paste the IP server address into the web browser URL (usually http://localhost:3000) to use the application.

Sign up and login to keep track of and share your recipes. Or, you can use this pre-made user account setting to login:

    $ username: lorem
    $ email: lorem@email.com
    $ password: Password1!

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/nichia/kitchenandrecipes.

## License
The application is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
