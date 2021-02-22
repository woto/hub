# frozen_string_literal: true

module Elastic
  class CheckIndexExists
    include ApplicationInteractor

    class Contract < Dry::Validation::Contract
      params do
        required(:index_name).filled(:string)
      end
    end

    before do
      contract = Contract.new.call(context.to_h)
      raise StandardError, contract.errors.to_h if contract.failure?
    end

    def call
      client = Elasticsearch::Client.new Rails.application.config.elastic

      context.object = client.indices.exists(index: context.index_name)
      unless context.object
        Rails.logger.info(message: 'There is no such index', index: context.index_name)
        context.fail!
      end
    end
  end
end
