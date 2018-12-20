Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#home"

  devise_for :users, :controllers => {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: [:show] do
    resources :recipes, only: [:show, :index, :new, :edit]
  end

  resources :recipes

end
