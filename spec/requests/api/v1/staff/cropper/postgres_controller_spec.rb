# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Staff::Cropper::PostgresController, type: :request do
  include_examples 'restricted in production', '/api/v1/staff/cropper/postgres/crop'
end
