# frozen_string_literal: true

module Api
  module V1
    # List feeds
    class FeedsController < BaseController
      def index
        client = Elasticsearch::Client.new Rails.application.config.elastic
        indices = client.cat.indices(
          format: 'json',
          index: Elastic::IndexName.all_offers
        )
        indices.map! do |index|
          {
            index: Elastic::IndexName.offers_crop(index['index']),
            count: index['docs.count'],
            uuid: index['uuid']
          }
        end
        if params[:q].present?
          indices.select! do |index|
            index[:index].downcase.include? params[:q].downcase
          end
          indices.compact!
        end
        page, per = PaginateRule.call(params)
        paginatable_array = Kaminari
                            .paginate_array(indices, total_count: indices.count)
                            .page(page)
                            .per(per)
        render json: { items: paginatable_array, totalCount: indices.count }
      end
    end
  end
end
