require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :notes, only: [] do
      member do
        put 'auth/password/update', to: 'passwords#update_password' # Added from new code
        get 'confirm', to: 'notes#confirm'
        put '', to: 'notes#update'
        patch '/notes/:id/autosave', to: 'notes#autosave' # Kept from existing code
      end
    end
  end
  
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
  post '/api/auth/2fa/verify', to: 'auth#verify_two_factor' # Kept from existing code
end
