require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :notes, only: [] do
      member do
        post '/auth/session', to: 'sessions#authenticate' # Kept the authenticate action from the existing code
        put '', to: 'notes#update'
        get 'confirm', to: 'notes#confirm'
        patch '/autosave', to: 'notes#autosave' # Corrected the autosave route from the existing code
      end
    end
  end
  
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
