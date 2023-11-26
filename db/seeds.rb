# frozen_string_literal: true

GlobalHelper.create_elastic_indexes

# NOTE: without this invocation, we must run migrations and seeding
# in separate executions. Otherwise, it will exit with an error due to
# the cache of model's columns during migration
User.reset_column_information

User.create!(
  email: 'admin@example.com',
  password: 'password',
  role: 'admin'
)
