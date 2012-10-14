Tripbudget::Application.routes.draw do

  root to: 'home#index'

  resources :trips, only: %w(index new create show edit update destroy) do
    member do
      get :summary
    end
    resources :destinations, only: %w(show edit update) do
      member do
        post :minor_update
        post :create_comment
      end
    end
  end

  resources :users, only: 'show'
  resources :invitations, only: 'show'

  # Authentication
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

end
