# frozen_string_literal: true

module Elastic
  class RefreshOffersIndex
    include ApplicationInteractor

    def call
      index_name = Elastic::IndexName.offers
      context.object = GlobalHelper.elastic_client.indices.refresh(index: index_name)
    end
  end
end
