# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  resources :template3s
  # get 'post_categories/index'
  # mount Yabeda::Prometheus::Exporter => "/metrics"

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :filters do
    resources :dates
  end
  resources :template1s
  resources :template2s
  devise_scope :user do
    Rails.configuration.oauth_providers.each do |provider|
      get "/users/auth/#{provider}/callback" => 'users/omniauth_callbacks#callback', defaults: { provider: provider }
    end
  end

  scope '(:locale)', constraints: LocalesConstraint.new do
    devise_for :users,
               path: 'auth',
               path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 password: 'password',
                 confirmation: 'verification',
                 unlock: 'unblock',
                 registration: 'register',
                 sign_up: 'new'
               },
               controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations',
                 confirmations: 'users/confirmations',
                 passwords: 'users/passwords',
                 unlocks: 'users/unlocks'
               }
    # sign_out_via: [*::Devise.sign_out_via, ActiveAdmin.application.logout_link_method].uniq

    # resources :advertiser_filter_forms
    # resources :feed_filter_forms

    namespace :ajax do
      resources :categories, controller: 'post_categories', only: %i[index]
      resources :tags, controller: 'post_tags', only: %i[index]
    end

    scope module: 'tables' do
      get '/favorites', to: 'favorites#index'
    end

    resources :favorites do
      collection do
        get :list
        get :refresh
        post :write
        get :items
        get :select
      end
    end

    resources :advertisers
    scope module: 'tables' do
      resources :post_categories
      resources :offers, only: %i[index]
      resources :accounts
      resources :transactions
      resources :checks
      resources :posts
      resources :feeds do
        member do
          get :count
          get :logs
          patch :prioritize
        end
        resources :offers, only: %i[index]
      end
      resources :users do
        post :impersonate, on: :member
        post :stop_impersonating, on: :collection
      end
      resources :news do
        collection do
          get 'month/:month', action: :by_month
          get 'tag/:tag', action: :by_tag, as: :by_tag
        end
      end
      resources :help do
        collection do
          get 'tag/:tag', action: :by_tag, as: :by_tag
        end
      end
    end
    resources :promotions
    resources :offer_embeds, only: %i[create]
    namespace :table do
      resources :columns
      resources :workspaces
    end
    resources :autocompletes
    namespace 'settings' do
      devise_scope :user do
        scope path_names: { edit: '' } do
          resource 'profile'
          resource 'email'
          resource 'password'
          resource 'avatar'
          resource 'danger_zone'
        end
      end
    end
    get 'dashboard', to: 'dashboard#index'
    get 'articles' => 'articles#index'
    get 'articles/:date/:title' => 'articles#show', as: 'article'
    root to: 'homepage#index'
  end
end
