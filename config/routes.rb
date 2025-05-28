Rails.application.routes.draw do
  # Onboarding routes
  get "onboarding", to: "onboarding#index"
  get "onboarding/:step", to: "onboarding#show", as: :onboarding_step
  patch "onboarding/:step", to: "onboarding#update"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Marketing pages (public)
  get "/", to: "pages#landing", as: :landing
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
  post "/contact", to: "pages#create_contact", as: :create_contact
  get "/demo", to: "pages#demo", as: :demo

  # Root route for authenticated users
  root "dashboard#index"

  # Authentication
  devise_for :users

  # Main application routes
  resources :assistants do
    member do
      patch :toggle_active
      get :analytics
    end

    resources :leads, except: [ :destroy ] do
      resources :conversations, only: [ :show, :create ]
    end
  end

  resources :leads do
    member do
      patch :update_status
      get :call_history
    end
  end

  resources :conversations do
    resources :transcripts, only: [ :index, :show ]
    member do
      get :analytics
      patch :update_score
    end
  end

  resources :appointments do
    member do
      patch :confirm
      patch :reschedule
      patch :cancel
    end
  end

  # Dashboard and analytics
  get "/dashboard", to: "dashboard#index"
  get "/analytics", to: "dashboard#analytics"

  # API routes for external integrations
  namespace :api do
    namespace :v1 do
      resources :webhooks, only: [ :create ]
      resources :conversations, only: [ :create, :update ]
      resources :leads, only: [ :create, :update ]
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Health check for monitoring
  get "/health", to: "health#check"
end
