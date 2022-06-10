# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  mount API::Root => '/'
  mount ImageUploader.derivation_endpoint => '/derivations/image'

  # mount Yabeda::Prometheus::Exporter => "/metrics"

  scope constraints: WebsiteConstraint.new do
    root to: 'tables/articles#index', as: :articles
    get '/robots.txt', to: 'robots#index'

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

  get '/robots.txt', to: 'robots#index'
  # TODO: to test
  get "/#{ENV.fetch('INDEX_NOW_KEY')}", to: 'index_now#index', as: :index_now

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
      resources :entities, only: [:index]
      resources :mentions, only: [:index]
      resources :favorites, only: [:index]
      resources :advertisers, only: [:index] do
        resources :offers, only: [:index]
      end
      resources :feeds, only: [:index] do
        resources :offers, only: [:index]
      end
      resources :post_categories, only: [:index]
      resources :realms, only: [:index]
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

    resources :accounts
    resources :advertisers
    resources :checks
    resources :entities do
      member do
        get :popover
      end
    end
    namespace :mentions do
      resources :entities, only: %i[edit new create update] do
        collection do
          get :assign
          get :search
        end
        member do
          get :card
        end
      end
    end
    resources :mentions
    resources :post_categories do
    end
    namespace :post_categories do
      resource :import, only: %i[create new]
    end
    resources :realms
    resources :posts

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

    resources :offers, only: [:index] do
      member do
        get :modal_card
      end
    end

    # resources :promotions
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
          resource 'api_key'
        end
      end
    end

    namespace :ajax do
      namespace :post_categories do
        resources :empties, only: %i[index]
      end
      resources :users, controller: 'users', only: %i[index]
    end

    get 'dashboard', to: 'dashboard#index'
    get 'api_docs', to: 'api_docs#index'

    root to: 'homepage#index'

    get 'landing1', to: 'landing1#index'
  end
end
