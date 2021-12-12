# frozen_string_literal: true

module Elastic
  class DeleteIndex
    include ApplicationInteractor

    contract do
      params do
        required(:index).filled(type?: IndexStruct)
        optional(:ignore_unavailable).maybe(:bool)
      end
    end

    def call
      Rails.logger.info(message: 'Deleting elasticsearch index', index: context.index.scoped)
      GlobalHelper.elastic_client.indices.delete(
        index: context.index.scoped, ignore_unavailable: context.ignore_unavailable
      )
    end
  end
end
