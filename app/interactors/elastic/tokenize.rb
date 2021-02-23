# frozen_string_literal: true

# # frozen_string_literal: true
#
module Elastic
  class Tokenize
    include ApplicationInteractor

    class Contract < Dry::Validation::Contract
      params do
        required(:q).filled(:string)
      end
    end

    before do
      contract = Contract.new.call(context.to_h)
      raise StandardError, contract.errors.to_h if contract.failure?
    end

    def call
      index_name = Elastic::IndexName.tokenizer

      result = client.indices.analyze(
        index: index_name,
        body: {
          analyzer: 'default',
          text: context.q
        }
      )
      context.object = result['tokens'].map { |t| t['token'] }
    end
  end
end
