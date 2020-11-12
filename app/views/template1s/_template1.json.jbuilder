# frozen_string_literal: true

json.extract! template1, :id, :name, :gender, :created_at, :updated_at
json.url template1_url(template1, format: :json)
