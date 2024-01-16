require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :notes, only: [] do
      member do
        get '', to: 'notes#index' # Added the index action from the new code
        get 'confirm', to: 'notes#confirm'
        put '', to: 'notes#update' # This line was duplicated in the existing code, kept only one
      end
      patch '/notes/:id/autosave', to: 'notes#autosave' # Kept the autosave action from the existing code
    end
  end
  
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
