# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Staff::Cropper::ElasticController, type: :request do
  include_examples 'restricted in production', '/api/v1/staff/cropper/elastic/crop'
end
