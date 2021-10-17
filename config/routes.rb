# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # mount Yabeda::Prometheus::Exporter => "/metrics"

  scope constraints: WebsiteConstraint.new do
    root to: 'tables/articles#index', as: :articles
    get '/robots.txt', to: 'robots#index', as: :robots

    scope controller: 'tables/articles', as: :articles do
      get 'month/:month', action: :by_month, as: :by_month
      get 'tag/:tag', action: :by_tag, as: :by_tag, constraints: { tag: %r{[^/]*} }
      get 'category/:category_id', action: :by_category, as: :by_category
    end
    namespace :frames do
      namespace :articles do
        get 'month(/:month)', to: 'month#index', as: :month
        get 'tag(/:tag)', to: 'tag#index', as: :tag, constraints: { tag: %r{[^/]*} }
        get 'category(/:category_id)', to: 'category#index', as: :category
      end
    end
    resources :articles, only: :show
  end

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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

    scope module: 'tables' do
      resources :accounts, only: [:index]
      resources :checks, only: [:index]
      resources :favorites, only: [:index]
      resources :advertisers, only: [:index] do
        resources :offers, only: [:index]
      end
      resources :feeds, only: [:index] do
        resources :offers, only: [:index]
      end
      resources :post_categories, only: [:index]
      resources :realms, only: [:index]
      # TODO: remove
      resources :categories, only: [:index] do
        resources :offers, only: [:index]
      end
      resources :feed_categories, only: [:index] do
        resources :offers, only: [:index]
      end
      resources :offers, only: [:index]
      resources :posts, only: [:index]
      resources :transactions, only: [:index]
      resources :users, only: [:index]
    end

    namespace :frames do
      namespace :articles do
        get 'latest', to: 'latest#index', as: :latest
      end
    end

    namespace :widgets do
      resources :simples
    end
    resources :widgets

    # TODO
    resources :accounts
    resources :advertisers
    resources :checks
    resources :post_categories
    resources :realms
    resources :favorites do
      collection do
        get :navbar_favorite_list
        get :dropdown_list
        get :update_star
      end
    end
    resources :users do
      post :impersonate, on: :member
      post :stop_impersonating, on: :collection
    end

    # sign_out_via: [*::Devise.sign_out_via, ActiveAdmin.application.logout_link_method].uniq

    resources :feeds do
      member do
        get :logs
        # NOTE: not tested
        get :shrinked
        patch :prioritize
      end
    end

    # NOTE: temporary workaround for "shared_search_everywhere" passing tests.
    # It's not needed for working application. Just for tests.
    resources :offers, only: [:index] do
      member do
        get :modal_card
      end
    end
    resources :post_categories, only: [:index]
    resources :realms, only: [:index]
    resources :feed_categories, only: [:index]
    resources :transactions, only: [:index]

    resources :posts

    resources :promotions
    namespace :table do
      resources :columns
      resources :workspaces
      resource :filters, only: %i[create update], path_names: { create: '' }
    end

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
      namespace :post_categories do
        resources :empties, only: %i[index]
        resources :leaves, only: %i[index]
      end
      resources :tags, controller: 'post_tags', only: %i[index]
      resources :users, controller: 'users', only: %i[index]
    end

    get 'dashboard', to: 'dashboard#index'
    root to: 'homepage#index'

    get 'landing1', to: 'landing1#index'
  end
end
