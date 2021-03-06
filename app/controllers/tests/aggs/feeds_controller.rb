class Tests::Aggs::FeedsController < ApplicationController
  layout 'backoffice'

  def index
    client = Elasticsearch::Client.new Rails.application.config.elastic
    query = Tests::Aggs::FeedsSearchQuery.call(advertiser_id: params[:advertiser_id], q: params[:q]).object
    @result = client.search(query)
  end
end
