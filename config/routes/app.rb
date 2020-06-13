# frozen_string_literal: true

Rails.application.routes.draw do
  devise_scope :user do
    Rails.configuration.oauth_providers.each do |provider|
      get "/users/auth/#{provider}/callback" => 'users/omniauth_callbacks#callback', defaults: { provider: provider }
    end
  end

  devise_for :users

  # Used for helpers in Rails mailers. Actually this routes processes React
  get 'users/password/edit', to: 'home#index', as: 'edit_password'

  get 'reset', to: 'home#index', as: 'reset_password'
  get 'proxy/:token', to: 'home#index', as: 'user_proxy'
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

  scope "(:locale)" do
    get 'dashboard', to: 'home#index'
    get 'articles' => 'articles#index'
    get 'articles/:date/:title' => 'articles#show', as: 'article'
  end


  get '*path', to: 'home#index', constraints: lambda { |request|
    request.params[:path]
           .ends_with?('login', 'register', 'restore', 'confirmation')
  }
  root to: 'home#index'
end
