require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'

  namespace :api do
    resources :notes, only: [:create] do
      member do
        get 'confirm', to: 'notes#confirm'
      end
    end
    patch '/notes/:id/autosave', to: 'notes#autosave'
  end

  # ... other routes ...
end
