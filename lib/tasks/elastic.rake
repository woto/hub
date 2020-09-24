# frozen_string_literal: true

Rails.logger = Logger.new(STDOUT)

namespace :hub do
  namespace :elastic do
    desc "Cleans all indexes"
    task truncate: :environment do
      client = Elasticsearch::Client.new Rails.application.config.elastic
      client.indices.delete index: ::Elastic::IndexName.wildcard
    end
  end
end
