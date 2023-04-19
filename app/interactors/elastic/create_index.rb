# frozen_string_literal: true

module Elastic
  class CreateIndex
    include ApplicationInteractor

    contract do
      params do
        required(:index).filled(type?: IndexStruct)
        optional(:ignore_unavailable).maybe(:bool)
      end
    end

    def call
      Rails.logger.info(message: 'Creating elasticsearch index', index: context.index.scoped)
      model = context.index.name.singularize.camelize.constantize
      unless [Entity, Mention, Topic].include? model
        mapping_name = "Columns::#{context.index.name.camelize}Mapping"
        form = mapping_name.constantize
        model.setup_index(form)
      end
      create_index(context.index, model)
    end

    private

    def create_index(index, model)
      GlobalHelper.elastic_client.indices.create(
        index: index.scoped,
        body: {
          settings: model.settings.to_hash,
          mappings: model.mappings.to_hash
        }
      )
    end
  end
end
