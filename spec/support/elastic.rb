# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    elastic_client.indices.delete index: ::Elastic::IndexName.wildcard
    GlobalHelper.create_elastic_indexes
  end
end
