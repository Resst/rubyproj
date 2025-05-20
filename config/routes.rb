Rails.application.routes.draw do


  scope "(:locale)", locale: /en|ru/ do

    match "/api/next_image", to: "application#next_image", via: :get
    match "/api/get_theme", to: "application#get_theme", via: :get
    match "/api/get_next_image", to: "application#get_next_image", via: :get
    match "/api/get_prev_image", to: "application#get_prev_image", via: :get
    match "/api/get_value_for_image", to: "application#get_value_for_image", via: :get
    match "/api/set_value", to: "application#set_value", via: [:get, :post]
    match "/api/login", to: "sessions#create", via: [:post]
    match "/api/register", to: "sessions#new_user", via: [:post]
    match "/api/signout", to: "sessions#new_user", via: [:post, :delete]
    resources :themes
    resources :images
    resources :values
    resources :users
    resources :posts
    resources :work

    get "main/index"
    get "main/help"
    get "main/contacts"
    get "main/about"

    root to: "main#index"

    match "help", to: "main#help", via: :get
    match "signin", to: "sessions#login", via: :get
    match "signup", to: "sessions#register", via: :get
    match "signout", to: "sessions#logout", via: [:get, :delete]
    # work
    match "work", to: "work#index", via: :get
    match "choose_theme", to: "work#choose_theme", via: [:get, :post]
    match "display_theme", to: "work#display_theme", via: :get
  end
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
