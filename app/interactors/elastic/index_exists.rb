# # frozen_string_literal: true
#
module Elastic
  class IndexExists
    include ApplicationInteractor

    def call
      index_name = Elastic::IndexName.offers
      client = Elasticsearch::Client.new Rails.application.config.elastic
      begin
        context.object = client.indices.exists(index: index_name)
        Rails.logger.info("There is no such index #{index_name}")
      end
    end
  end
end
