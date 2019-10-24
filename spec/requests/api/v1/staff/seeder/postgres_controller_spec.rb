# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Staff::Seeder::PostgresController, type: :request do
  include_examples 'restricted in production', '/api/v1/staff/seeder/postgres/create_user'
end
