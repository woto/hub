# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  # Client configuration
  Elasticsearch::Model.client = GlobalHelper.elastic_client

  # Pagination support
  Kaminari::Hooks.init if defined?(Kaminari::Hooks)
  Elasticsearch::Model::Response::Response.include Elasticsearch::Model::Response::Pagination::Kaminari
end
