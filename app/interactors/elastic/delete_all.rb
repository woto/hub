# frozen_string_literal: true

require 'rails_helper'

module Elastic
  class DeleteAll
    include ApplicationInteractor

    def call
      client = Elasticsearch::Client.new Rails.application.config.elastic
      client.indices.delete index: ::Elastic::IndexName.wildcard
    end
  end
end
