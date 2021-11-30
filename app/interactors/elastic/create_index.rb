# frozen_string_literal: true

module Elastic
  class CreateIndex
    include ApplicationInteractor

    contract do
      params do
        required(:index_name).filled(:string)
        optional(:ignore_unavailable).maybe(:bool)
      end
    end

    def call
      model = context.index_name.camelize.constantize
      form = "Columns::#{context.index_name.camelize}Form".constantize

      model.setup_index(form)
      create_index(model)
    end

    private

    def create_index(model)
      GlobalHelper.elastic_client.indices.create(
        index: model.index_name,
        body: {
          settings: model.settings.to_hash,
          mappings: model.mappings.to_hash
        }
      )
    end
  end
end
