Tripbudget::Application.routes.draw do

  root to: 'home#index'

  resources :trips, only: %w(index new create show edit update destroy) do
    resources :destinations, only: %w(index show edit update destroy) do
      member do
        post :minor_update
      end
    end
  end

  resources :users, only: 'show'
  resources :invitations, only: 'show'

  # Authentication
  match 'auth/twitter/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

end
