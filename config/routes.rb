# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper

  devise_scope :user do
    Rails.configuration.oauth_providers.each do |provider|
      get "/users/auth/#{provider}/callback" => 'users/omniauth_callbacks#callback', defaults: { provider: provider }
    end
  end

  devise_for :users, defaults: { format: :json }, path: 'api/v1/users', controllers: {
    registrations: 'api/v1/users/registrations',
    confirmations: 'api/v1/users/confirmations',
    passwords: 'api/v1/users/passwords',
    sessions: 'api/v1/users/sessions',
    unlocks: 'api/v1/users/unlocks'
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource 'pet', controller: 'pet'

      namespace :users do
        resources :binds
      end
    end
  end

  root to: 'home#index'
end
