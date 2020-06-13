# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::OffersController, type: :request do
  before(:all) do
    Staff::Cropper::Elastic.crop
    Staff::Seeder::Elastic.pagination
  end

  context 'without feed' do
    xit 'Searches by name' do
      get '/api/v1/offers?q=one_my_offer_name'
      expect(json_response_body['totalCount']).to eq(1)

      expect(json_response_body['items'].length).to eq(1)
      expect(json_response_body['items'].first).to include(
        '_index' => ::Elastic::IndexName.offers('zero_my_index_name'),
        '_type' => '_doc',
        '_id' => '22'
      )
      expect(json_response_body['items'].first['_source']).to match(
        'name' => '[one] [my_offer_name] one_my_offer_name',
        'price' => an_instance_of(Float),
        'currencyId' => an_instance_of(String),
        'url' => an_instance_of(String),
        'picture' => an_instance_of(Array)
      )
    end

    xit 'Respect "per" param' do
      get '/api/v1/offers?per=5'
      expect(json_response_body['totalCount']).to eq(41)
      expect(json_response_body['items'].length).to eq(5)
    end

    xit 'Respects "page" param' do
      get '/api/v1/offers?page=5'
      expect(json_response_body['totalCount']).to eq(41)
      expect(json_response_body['items'].length).to eq(1)
    end
  end

  context 'with feed' do
    xit 'Searches by name' do
      get '/api/v1/feeds/zero_my_index_name/offers?q=one_my_offer_name'
      expect(json_response_body['totalCount']).to eq(1)

      expect(json_response_body['items'].length).to eq(1)
      expect(json_response_body['items'].first).to include(
        '_index' => ::Elastic::IndexName.offers('zero_my_index_name'),
        '_type' => '_doc',
        '_id' => '22'
      )
      expect(json_response_body['items'].first['_source']).to match(
        'name' => '[one] [my_offer_name] one_my_offer_name',
        'price' => an_instance_of(Float),
        'currencyId' => an_instance_of(String),
        'url' => an_instance_of(String),
        'picture' => an_instance_of(Array)
      )
    end

    xit 'Respect "per" param' do
      get '/api/v1/feeds/zero_my_index_name/offers?per=5'
      expect(json_response_body['totalCount']).to eq(21)
      expect(json_response_body['items'].length).to eq(5)
    end

    xit 'Respects "page" param' do
      get '/api/v1/feeds/zero_my_index_name/offers?page=3'
      expect(json_response_body['totalCount']).to eq(21)
      expect(json_response_body['items'].length).to eq(1)
    end

  end
end
