require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :notes, only: [] do
      member do
        put '', to: 'notes#update'
        get 'confirm', to: 'notes#confirm'
        put '', to: 'notes#update' # Added the update action from the new code
      end
      patch '/notes/:id/autosave', to: 'notes#autosave' # Kept the autosave action from the existing code
    end
  end
  
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
