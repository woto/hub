# frozen_string_literal: true

module Elastic
  class DeleteIndex
    include ApplicationInteractor

    class Contract < Dry::Validation::Contract
      params do
        required(:index_name).filled(:string)
        optional(:ignore_unavailable).maybe(:bool)
      end
    end

    before do
      result = Contract.new.call(context.to_h)
      raise result.inspect if result.failure?
    end

    def call
      Rails.logger.info(message: 'Deleting elasticsearch index', index: context.index_name)
      client = Elasticsearch::Client.new Rails.application.config.elastic
      client.indices.delete(index: context.index_name, ignore_unavailable: context.ignore_unavailable)
    end
  end
end
