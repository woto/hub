# frozen_string_literal: true

# require 'rails_helper'

module Elastic
  class DeleteOffers
    include ApplicationInteractor

    def call
      client = Elasticsearch::Client.new Rails.application.config.elastic
      client.indices.delete index: ::Elastic::IndexName.offers
    end
  end
end
