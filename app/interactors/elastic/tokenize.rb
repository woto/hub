# frozen_string_literal: true

# # frozen_string_literal: true
#
module Elastic
  class Tokenize
    include ApplicationInteractor

    contract do
      params do
        required(:q).filled(:string)
      end
    end


    def call
      index_name = Elastic::IndexName.tokenizer

      result = GlobalHelper.elastic_client.indices.analyze(
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
