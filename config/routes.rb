Rails.application.routes.draw do
  devise_for :users

  root 'foods#index'
  resources :recipe_foods

  resources :foods
  resources :recipes do
      resources :recipe_foods do
        put 'increment_quantity', on: :member
      end
      member do
    put :make_private
  end
  end
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
