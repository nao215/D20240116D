require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :notes, only: [] do
      member do
        get 'confirm', to: 'notes#confirm'
        put '', to: 'notes#update'
        patch 'autosave', to: 'notes#autosave' # Keep the existing autosave route
      end
    end
    # Add the new autosave route outside of the member block
    patch '/notes/:id/autosave', to: 'notes#autosave'
    
    # Keep the existing user and authentication routes
    post '/users/confirm-email', to: 'users#confirm_email'
    post '/users/login', to: 'users#login'
    post '/auth/session', to: 'sessions#authenticate'
    post '/auth/2fa/verify', to: 'auth#verify_two_factor' # Keep the existing 2FA verify route
    
    # Add the new password reset route
    post '/users/request-password-reset', to: 'passwords#request_password_reset'
  end
  
  # Keep the existing health check and swagger routes
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
