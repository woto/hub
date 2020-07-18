# frozen_string_literal: true

if Rails.env.development?
  User.create!(email: 'admin@example.com',
               password: 'password',
               password_confirmation: 'password',
               role: 'admin')
end
