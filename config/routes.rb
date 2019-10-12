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
  get 'restore', to: 'home#index', as: 'restore_password'
  get 'reset', to: 'home#index', as: 'reset_password'
  get 'confirm', to: 'home#index', as: 'confirm_password'
  get 'proxy/:token', to: 'home#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource 'profile', controller: 'profile'
      namespace :staff do
        resource :clean_stores do
          collection do
            get 'start'
            get 'test'
            get 'clean'
          end
        end
      end

      namespace :users do
        resources :binds
      end
    end
  end

  root to: 'home#index'
end
