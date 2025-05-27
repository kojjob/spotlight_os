Rails.application.routes.draw do
  get "appointments/index"
  get "appointments/show"
  get "appointments/new"
  get "appointments/create"
  get "appointments/edit"
  get "appointments/update"
  get "conversations/index"
  get "conversations/show"
  get "conversations/new"
  get "conversations/create"
  get "leads/index"
  get "leads/show"
  get "leads/new"
  get "leads/create"
  get "leads/edit"
  get "leads/update"
  get "assistants/index"
  get "assistants/show"
  get "assistants/new"
  get "assistants/create"
  get "assistants/edit"
  get "assistants/update"
  get "assistants/destroy"
  get "dashboard/index"
  get "dashboard/analytics"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
