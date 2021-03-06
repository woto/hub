# TODO: remove
class Tests::Aggs::AdvertisersController < ApplicationController
  layout 'backoffice'

  def index
    client = Elasticsearch::Client.new Rails.application.config.elastic
    query = Tests::Aggs::AdvertisersSearchQuery.call(q: params[:q]).object
    @result = client.search(query)
  end
end
