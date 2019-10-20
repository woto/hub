# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Staff::Seeder::ElasticController, type: :request do
  it 'Fills elastic for pagination tests' do
    elastic_client.indices.delete index: ::Elastic::IndexName.all_offers
    get '/api/v1/staff/seeder/elastic/pagination'
    indices = elastic_client.cat.indices(
      format: 'json',
      index: Elastic::IndexName.all_offers
    )
    expect(indices.length).to eq(21)
    my_index, others_indicies = indices.partition do |index|
      index['index'] == ::Elastic::IndexName.offers('zero_my_index_name')
    end
    expect(others_indicies.map { |ind| ind['docs.count'] }).to all(eq '1')
    expect(my_index.map { |ind| ind['docs.count'] }).to all(eq '21')
  end
end
