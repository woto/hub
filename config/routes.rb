# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # get 'post_categories/index'
  # mount Yabeda::Prometheus::Exporter => "/metrics"

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :filters do
    resources :dates
  end

  devise_scope :user do
    Rails.configuration.oauth_providers.each do |provider|
      get "/users/auth/#{provider}/callback" => 'users/omniauth_callbacks#callback', defaults: { provider: provider }
    end
  end

  scope '(:locale)', constraints: LocalesConstraint.new do
    # TODO: remove. demo modal
    get 'modal' => 'modal#index'

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

    scope module: 'tables' do
      resources :accounts, only: [:index]
      resources :checks, only: [:index]
      resources :favorites, only: [:index]
      resources :feeds, only: [:index] do
        resources :offers, only: [:index]
      end
      resources :help, only: [:index]
      # TODO?
      # get 'articles/:date/:title' => 'articles#show', as: 'article'
      resources :news, only: [:index] do
        collection do
          get 'month/:month', action: :by_month, as: :by_month
          get 'tag/:tag', action: :by_tag, as: :by_tag
        end
      end
      resources :offers, only: [:index]
      resources :posts, only: [:index]
      resources :transactions, only: [:index]
      resources :users, only: [:index]
    end

    # TODO
    resources :accounts
    resources :advertisers

    resources :news

    resources :checks
    resources :favorites do
      collection do
        get :dropdown_list
        get :update_star
        post :write_post
        get :modal_items
        get :modal_select
      end
    end
    resources :users do
      post :impersonate, on: :member
      post :stop_impersonating, on: :collection
    end

    # sign_out_via: [*::Devise.sign_out_via, ActiveAdmin.application.logout_link_method].uniq

    # resources :advertiser_filter_forms
    # resources :feed_filter_forms

    resources :feeds do
      member do
        get :logs
        patch :prioritize
      end
    end

    resources :posts

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

    namespace :ajax do
      resources :categories, controller: 'post_categories', only: %i[index]
      resources :tags, controller: 'post_tags', only: %i[index]
      resources :users, controller: 'users', only: %i[index]
    end

    namespace :frames do
      namespace :news do
        get 'month(/:month)', to: 'month#index', as: :month
        get 'tag(/:tag)', to: 'tag#index', as: :tag
        get 'latest', to: 'latest#index', as: :latest
      end
    end

    get 'dashboard', to: 'dashboard#index'
    root to: 'homepage#index'
  end
end
