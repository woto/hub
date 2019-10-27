# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper

  devise_scope :user do
    Rails.configuration.oauth_providers.each do |provider|
      get "/users/auth/#{provider}/callback" => 'users/omniauth_callbacks#callback', defaults: { provider: provider }
    end
  end

  # devise sessions controller is replaced by doorkeeper /oauth/token
  # which allow to use oauth2 password flow authentication
  devise_for :users, defaults: { format: :json }, path: 'api/v1/users',
                     skip: :sessions, controllers: {
                       registrations: 'api/v1/users/registrations',
                       confirmations: 'api/v1/users/confirmations',
                       passwords: 'api/v1/users/passwords',
                       unlocks: 'api/v1/users/unlocks'
                     }

  # Used for helpers in Rails mailers. Actually this routes processes React
  get 'users/password/edit', to: 'home#index', as: 'edit_password'
  get 'login', to: 'home#index', as: 'user_login'
  get 'register', to: 'home#index', as: 'user_register'
  get 'restore', to: 'home#index', as: 'restore_password'
  get 'reset', to: 'home#index', as: 'reset_password'
  get 'confirm', to: 'home#index', as: 'confirm_password'
  get 'proxy/:token', to: 'home#index'
  get 'dashboard', to: 'home#index'

  resources :offers, only: %i[index] do
    get 'login', on: :collection, to: 'home#index'
  end
  resources :feeds, controller: 'home', action: 'index', only: %i[index] do
    resources :offers, controller: 'offers', action: 'index', only: %i[index] do
      get 'login', on: :collection, to: 'home#index'
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :feeds, only: %i[index] do
        resources :offers, only: %i[index]
      end
      resources :offers, only: %i[index]
      resource 'profile', controller: 'profile'
      namespace :staff do
        namespace :cropper do
          namespace 'elastic' do
            get 'crop'
          end
          namespace 'postgres' do
            get 'crop'
          end
        end
        namespace 'seeder' do
          namespace 'elastic' do
            get 'pagination'
          end
          namespace 'postgres' do
            get 'create_user'
            get 'create_unconfirmed_user'
            get 'get_user'
            get 'send_reset_password_instructions'
            get 'send_confirmation_instructions'
          end
        end
      end

      namespace :users do
        resources :binds, only: [:update]
      end
    end
  end

  root to: 'home#index'
end
