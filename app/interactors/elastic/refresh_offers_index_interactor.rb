# frozen_string_literal: true

module Elastic
  class RefreshOffersIndexInteractor
    include ApplicationInteractor

    def call
      index = Elastic::IndexName.pick('offers')
      # GlobalHelper.elastic_client.indices.refresh
      context.object = GlobalHelper.elastic_client.indices.refresh(index: index.scoped)
    end
  end
end
