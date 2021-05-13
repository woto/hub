# frozen_string_literal: true

module Elastic
  class DeleteIndex
    include ApplicationInteractor

    contract do
      params do
        required(:index_name).filled(:string)
        optional(:ignore_unavailable).maybe(:bool)
      end
    end



    def call
      Rails.logger.info(message: 'Deleting elasticsearch index', index: context.index_name)
      client.indices.delete(index: context.index_name, ignore_unavailable: context.ignore_unavailable)
    end
  end
end
