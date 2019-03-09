Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#home"

  devise_for :users,
    controllers: {
      omniauth_callbacks: "users/omniauth_callbacks",
      registrations: "registrations"
  }

  resources :users, only: [:show] do
    resources :recipes #, only: [:show, :index, :new, :edit, :update]
  end

  resources :recipes, only: [:index, :create]
  
  resources :recipes, only: [:show] do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :categories, only: [:show, :index]

  post '/recipes/:id/copy', to: 'recipes#create_copy', as: 'recipe_copy'

  get 'search', to: 'recipes#search', as: 'recipe_search'

  # api json datatype
  get '/api/recipes', to: 'api#index', as: 'api_recipes'
  get '/api/users/:id/recipes', to: 'api#index', as: 'api_user_recipes'
  get '/api/recipes/:id', to: 'api#show', as: 'api_recipe'

  # helper routes
  get '/current_user', to: 'users#current_username'
end
