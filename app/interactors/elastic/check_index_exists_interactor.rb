# frozen_string_literal: true

module Elastic
  class CheckIndexExistsInteractor
    include ApplicationInteractor

    contract do
      params do
        required(:index).filled(type?: IndexStruct)
        optional(:allow_no_indices).maybe(:bool)
      end
    end


    def call
      context.object = GlobalHelper.elastic_client.indices.exists(
        index: context.index.scoped, allow_no_indices: context.allow_no_indices
      )
      unless context.object
        Rails.logger.info(message: 'There is no such index', index: context.index.scoped)
        context.fail!
      end
    end
  end
end
