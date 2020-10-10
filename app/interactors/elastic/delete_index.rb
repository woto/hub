# # frozen_string_literal: true
#
module Elastic
  class DeleteIndex
#     include ApplicationInteractor
#
#     def call
#       index_name = Elastic::IndexName.offers(context.feed.slug)
#       client = Elasticsearch::Client.new Rails.application.config.elastic
#       begin
#         client.indices.delete(index: index_name)
#       rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
#         Rails.logger.info("There is no such index #{index_name}")
#       end
#     end
  end
end
