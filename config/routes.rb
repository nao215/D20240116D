require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :notes, only: [] do
      member do
        post '', to: 'notes#create' # Added from new code to allow creating notes
        put '', to: 'notes#update'
        get 'confirm', to: 'notes#confirm'
        patch '/autosave', to: 'notes#autosave'
        get '', to: 'notes#index' # Added from existing code to allow listing notes
        delete '', to: 'notes#destroy' # Added from existing code to allow deleting notes
      end
    end
    post '/users/confirm-email', to: 'users#confirm_email'
    post '/users/login', to: 'users#login'
    post '/auth/session', to: 'sessions#authenticate'
    post '/auth/2fa/verify', to: 'auth#verify_two_factor'
    post '/users/confirm-password-reset', to: 'passwords#confirm_password_reset'
  end
  
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
