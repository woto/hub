# frozen_string_literal: true

class FeedsController < ApplicationController
  layout 'dashboard'
  skip_before_action :authenticate_user!

  def index
    @feeds = Feed.order("last_succeeded_at DESC NULLS LAST").page(params[:page]).per(params[:per])

    # client = Elasticsearch::Client.new Rails.application.config.elastic
    # indices = client.cat.indices(
    #   format: 'json',
    #   index: Elastic::IndexName.all_offers
    # )
    #
    # indices.map! do |index|
    #   {
    #     index: Elastic::IndexName.offers_crop(index['index']),
    #     count: index['docs.count'],
    #     uuid: index['uuid']
    #   }
    # end
    #
    # if params[:q].present?
    #   indices.select! do |index|
    #     index[:index].downcase.include? params[:q].downcase
    #   end
    #   indices.compact!
    # end
    #
    # page, per = PaginateRule.call(params, 10)
    # @total_count = indices.count
    # @feeds = Kaminari
    #          .paginate_array(indices, total_count: @total_count)
    #          .page(page)
    #          .per(per)
  end
end
