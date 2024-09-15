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
    resources :admins, except: [:edit, :update]
    resources :maintainers, except: [:edit, :update]
    resources :utility_staff, except: [:edit, :update]
    resources :rooms, except: [:edit, :update]
    resources :tenants, except: [:edit, :update, :show]

    resources :properties, except: [:edit, :update] do
      member do
        get :property_units
      end
    end

    resources :property_units, only: :index do
      member do
        get :rooms
      end
    end

    resources :rooms, except: [:edit, :update] do
      member do
        get :decks
      end
    end
  end

  resources :onboarding, only: [:show, :update]
  resources :valid_ids, only: [:update]
  resources :profile, only: [:show] do
    member do
      patch :update_status
    end
  end
end
