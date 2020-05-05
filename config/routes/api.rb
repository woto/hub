Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'environment', to: 'environment#index'

      resources :feeds, only: %i[index] do
        resources :offers, only: %i[index]
      end

      resources :posts do
        member do
          post 'images'
        end
      end

      resources :offers, only: %i[index]
      resource :users, only: %i[show]
      resource :profile, only: %i[show update]
      resource :avatar, only: %i[show update]

      namespace :users do
        resources :binds, only: [:update]
        resources :unbinds, only: [:destroy]
      end
    end
  end
end
