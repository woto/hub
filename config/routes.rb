# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :posts

  root to: 'home#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :posts
    end
  end
end
