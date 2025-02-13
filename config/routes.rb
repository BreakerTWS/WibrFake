Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  #get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  #get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  #get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root to: "sessions#index", as: :page_index
  get 'login/basic', to: 'sessions#basic', as: :basic_login
  post 'login/basic', to: 'sessions#basic_login', as: :basic_login_post
  get 'login/nauta', to: 'sessions#nauta', as: :nauta_login
  #get 'generate_204', to: 'sessions#nauta', as: :nauta_login
  post 'login/nauta', to: 'sessions#nauta_login', as: :nauta_login_post
  #post 'generate_204', to: 'sessions#nauta_login', as: :nauta_login_post
  #root to: 'sessions#basic', as: :basic_login
end
