Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
end
