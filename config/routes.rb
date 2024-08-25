Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }, path: '', path_names: { sign_in: 'sign_in'}

  # Defines the root path route ("/")
  root "dashboard/homepage#index"

  namespace :dashboard do
    resources :homepage, only: :index
    resources :admins, except: %i[edit update]
    resources :maintainers, except: %i[edit update]
    resources :caretakers, except: %i[edit update]
    resources :rooms, except: %i[edit update]
    resources :tenants, except: %i[edit update show]

    resources :properties, except: %i[edit update] do
      member do
        get :property_units
      end
    end

    resources :property_units, only: :index do
      member do
        get :rooms
      end
    end

    resources :rooms, except: %i[edit update] do
      member do
        get :decks
      end
    end
  end
end
