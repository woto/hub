# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::FeedsController, type: :request do
  before(:all) do
    Staff::Cropper::Elastic.crop
    Staff::Seeder::Elastic.pagination
  end

  xit 'Searches by name' do
    get '/api/v1/feeds?q=index'
    expect(json_response_body['totalCount']).to eq(1)
    expect(json_response_body['items'].first).to match(
      'count' => '21',
      'index' => 'zero_my_index_name',
      'uuid' => an_instance_of(String)
    )
  end

  xit 'Respect "per" param' do
    get '/api/v1/feeds?per=5'
    expect(json_response_body['totalCount']).to eq(21)
    expect(json_response_body['items'].length).to eq(5)
  end

  xit 'Respects "page" param' do
    get '/api/v1/feeds?page=3'
    expect(json_response_body['totalCount']).to eq(21)
    expect(json_response_body['items'].length).to eq(1)
  end
end
