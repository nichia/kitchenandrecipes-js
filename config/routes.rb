Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#home"

  devise_for :users, :controllers => {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: [:show] do
    resources :recipes #, only: [:show, :index, :new, :edit, :update]
  end

  resources :recipes, only: [:show, :index, :create]

  resources :categories, only: [:show, :index]

  post '/recipes/:id/copy', to: 'recipes#create_copy', as: 'recipe_copy'

  get 'search', to: 'recipes#search', as: 'recipe_search'

end
