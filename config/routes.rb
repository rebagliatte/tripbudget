Tripbudget::Application.routes.draw do

  root to: 'home#index'

  resources :trips, only: %w(index new create show edit update destroy)
  resources :destinations, only: %w(index new create show edit update destroy)
  resources :users, only: 'show'

  match 'auth/twitter/callback', to: 'sessions#create'

end
