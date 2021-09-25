# frozen_string_literal: true

GlobalHelper.create_elastic_indexes

User.create!(
  email: 'admin@example.com',
  password: 'password',
  role: 'admin'
)
