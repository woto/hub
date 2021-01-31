class Mixes::Search2Controller < ApplicationController
  def index
    client = Elasticsearch::Client.new Rails.application.config.elastic

    query = Mixes::OffersSearchQuery.call({q: params[:q], from: 0, size: 12}).object
    @results = client.search(query)
  end
end
