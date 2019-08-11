# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
end
