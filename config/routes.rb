# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  # mount Yabeda::Prometheus::Exporter => "/metrics"

  authenticate :user, lambda { |u| u.admin? } do
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

    # scope ':model' do
    #   resources 'displayed_columns'
    # end

    # resources :advertiser_filter_forms
    # resources :feed_filter_forms

    namespace :table do
      resources :columns
    end

    resources :autocompletes
    resources :advertisers

    resources :feeds do
      member do
        get :count
        get :logs
        patch :prioritize
      end
      resources :offers, only: %i[index] do
        get :categories, on: :collection
      end
    end
    resources :offers, only: %i[index]
    resource :embed, only: :show

    resources :posts
    resources :promotions

    namespace 'settings' do
      devise_scope :user do
        scope path_names: { edit: '' } do
          resource 'profile'
          resource 'email'
          resource 'password'
          resource 'avatar'
        end
      end
    end

    get 'dashboard', to: 'dashboard#index'

    get 'articles' => 'articles#index'
    get 'articles/:date/:title' => 'articles#show', as: 'article'

    resources :youtube

    root to: 'homepage#index'
  end
end
