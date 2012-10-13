Tripbudget::Application.routes.draw do

  root to: 'home#index'

  resources :trips, only: %w(index new create show edit update destroy) do
    resources :destinations, only: %w(index new create show edit update destroy)
  end
  resources :users, only: 'show'

end
