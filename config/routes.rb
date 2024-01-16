require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :notes, only: [] do
      member do
        get 'confirm', to: 'notes#confirm'
        put '', to: 'notes#update'
        patch 'autosave', to: 'notes#autosave'
      end
    end
    post '/users/confirm-email', to: 'users#confirm_email'
    post '/users/login', to: 'users#login'
    post '/auth/session', to: 'sessions#authenticate'
    post '/auth/2fa/verify', to: 'auth#verify_two_factor'
  end
  
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
