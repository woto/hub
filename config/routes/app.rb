# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper

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

  get 'reset', to: 'home#index', as: 'reset_password'
  get 'dashboard', to: 'home#index'
  get 'confirm', to: 'home#index', as: 'confirm_password'

  scope '/settings' do
    get 'email', to: 'home#index'
    get 'profile', to: 'home#index'
    get 'password', to: 'home#index'
    get 'social', to: 'home#index'
  end

  resources :offers, only: %i[index]
  resources :posts, to: 'home#index'
  resources :feeds, controller: 'home', action: 'index', only: %i[index] do
    resources :offers, controller: 'offers', action: 'index', only: %i[index]
  end

  get 'articles' => 'articles#index'
  get 'articles/:date/:title' => 'articles#show'

  get '*path', to: 'home#index', constraints: lambda { |request|
    request.params[:path]
           .ends_with?('login', 'register', 'restore', 'confirmation')
  }
  root to: 'home#index'
end
