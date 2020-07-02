# frozen_string_literal: true

module Staff
  module Cropper
    # Elastic first simple seeder used for tests
    class Elastic
      class << self
        # Removes all Elastic Search indexes
        def crop
          client = Elasticsearch::Client.new Rails.application.config.elastic
          client.indices.delete index: ::Elastic::IndexName.all_offers
          client.indices.delete index: ::Elastic::IndexName.all_categories
        end
      end
    end
  end
end
