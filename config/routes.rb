require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :notes, only: [] do
      member do
        get '', to: 'notes#index' # Added from new code to allow listing notes
        delete '', to: 'notes#destroy' # Added from new code to allow deleting notes
        put '', to: 'notes#update'
        get 'confirm', to: 'notes#confirm'
        patch '/autosave', to: 'notes#autosave' # Corrected the autosave route from the existing code
      end
      # Removed the duplicate put route for '/notes/:id' as it is already defined within the member block
    end
    post '/users/confirm-email', to: 'users#confirm_email'
    post '/users/login', to: 'users#login'
    post '/auth/session', to: 'sessions#authenticate' # Kept the authenticate action from the existing code
    post '/auth/2fa/verify', to: 'auth#verify_two_factor'
    post '/users/confirm-password-reset', to: 'passwords#confirm_password_reset' # Added the confirm_password_reset route from the new code
  end
  
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
