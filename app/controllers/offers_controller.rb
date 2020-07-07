# frozen_string_literal: true

class OffersController < ApplicationController
  layout 'dashboard'
  skip_before_action :authenticate_user!

  def index
    client = Elasticsearch::Client.new Rails.application.config.elastic

    page, per = PaginateRule.call(params, 10)
    request = search_request.merge(
      from: (page - 1) * per,
      size: per
    )

    result = client.search(request)
    offers = result['hits']['hits']

    result = client.count(search_request)
    @total_count = result['count']

    @offers = Kaminari
              .paginate_array(offers, total_count: @total_count)
              .page(page)
              .per(per)
  end

  private

  def search_request
    {
      index: ::Elastic::IndexName.offers(params[:feed_id] || '*'),
      body: {
        query: {
          query_string: {
            query: params[:q].presence || '*'
          }
        }
      }
    }
  end
end
