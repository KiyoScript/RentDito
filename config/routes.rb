Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }, path: '', path_names: {
    sign_in: 'sign_in',
    password: 'forgot_password/edit'
  }

  # Defines the root path route ("/")
  root "dashboard/homepage#index"

  namespace :dashboard do
    resources :homepage, only: :index
    resources :admins, except: [:edit, :update, :destroy]
    resources :maintenance_staffs, except: [:edit, :update, :destroy]
    resources :utility_staff, except: [:edit, :update]
    resources :tenants, except: [:edit, :update, :destroy]
    resources :rooms, except: [:edit, :update]
    resources :tickets do
      member do
        patch :assign_staff
        patch :close_ticket
      end
    end
    resources :tickets_history
    resources :properties do
      resources :property_units
      member do
        get :render_property_units
      end
    end

    resources :property_units, only: :index do
      member do
        get :rooms
        get :occupancy_data
      end
    end

    resources :rooms, except: [:edit, :update] do
      member do
        get :decks
      end
    end

    resources :billings, except: [:edit, :update] do
      collection do
        get :billing_data
      end
      member do
        post :new_monthly_bill_notification
      end
      resources :charges
    end

    resources :charges, only: :index
    resources :deposits, only: [:new, :create]
    resources :payments, only: [:new, :create]
    resources :feedbacks, only: :index


    resources :transactions do
      member do
        patch :mark_as_paid
        patch :mark_as_rejected
        patch :mark_as_done
      end
    end

    resources :transaction_history

    resources :notifications do
      member do
        patch :mark_as_read
      end
    end
  end

  resources :onboarding, only: [:show, :update]
  resources :account_settings, only: [:show, :update]
  resources :tenant do
    resources :tickets
    resources :tickets_history
  end
  resources :valid_ids, only: [:update]
  resources :profile, only: :show do
    member do
      patch :update_status
      patch :transfer
      patch :deactivate
    end
  end


  resources :balances do
    post :transfer, on: :collection
  end


  constraints(lambda { |req| req.env['warden'].user&.landlord? }) do
    mount MissionControl::Jobs::Engine, at: "/jobs", as: :mission_control_jobs
  end
end
