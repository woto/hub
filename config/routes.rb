# frozen_string_literal: true

Rails.application.routes.draw do
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

    resources :feeds, only: %i[index] do
      resources :offers, only: %i[index]
    end
    resources :offers, only: %i[index]
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
