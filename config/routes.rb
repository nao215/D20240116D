
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :notes, only: [] do
      member do
        get 'confirm', to: 'notes#confirm'
        put '', to: 'notes#update'
      end
      patch '/notes/:id/autosave', to: 'notes#autosave'
    end
  end
  
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
  post '/api/auth/2fa/verify', to: 'auth#verify_two_factor'
end
