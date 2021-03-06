class Tests::Aggs::FeedCategoriesController < ApplicationController
  layout 'backoffice'

  def index
    client = Elasticsearch::Client.new Rails.application.config.elastic
    query = Tests::Aggs::FeedCategoriesSearchQuery.call(feed_id: params[:feed_id], q: params[:q]).object
    @result = client.search(query)
  end
end
