# frozen_string_literal: true

# Client configuration
Elasticsearch::Model.client = Elasticsearch::Client.new Rails.application.config.elastic

# Pagination support
Kaminari::Hooks.init if defined?(Kaminari::Hooks)
Elasticsearch::Model::Response::Response.include Elasticsearch::Model::Response::Pagination::Kaminari
