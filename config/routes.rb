Tripbudget::Application.routes.draw do

  root to: 'home#index'

  resources :trips, only: %w(index new create show edit update destroy) do
    resources :destinations, only: %w(index show edit update destroy) do
      resources :expenses, only: %w(new) do
        collection do
          post :create_all
        end
      end
    end
  end

  resources :users, only: 'show'

end
