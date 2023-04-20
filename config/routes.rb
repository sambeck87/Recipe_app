Rails.application.routes.draw do
  devise_for :users

  root 'foods#index'
  get '/public_recipe', to:'recipes#public_recipe'
  resources :recipe_foods

  resources :foods
  resources :recipes do
      resources :recipe_foods do
        put 'increment_quantity', on: :member
        put 'decrement_quantity', on: :member
      end
      member do
    put :make_private
  end
  end
  resources :users
  resources :general_shopping_list, only: [:index]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
