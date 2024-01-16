require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :notes, only: [] do
      member do
        post '/users/register', to: 'users#register'
        post '/users/login', to: 'users#login'
        post '/auth/session', to: 'sessions#authenticate'
        put '', to: 'notes#update'
        get 'confirm', to: 'notes#confirm'
        patch '/autosave', to: 'notes#autosave'
      end
    end
  end
  
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
