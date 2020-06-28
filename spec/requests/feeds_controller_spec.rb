require 'rails_helper'

describe FeedsController do
  before(:all) do
    Staff::Cropper::Elastic.crop
    Staff::Seeder::Elastic.pagination
  end

  it 'Searches by name' do
    get '/feeds?q=index'
    expect(assigns[:total_count]).to eq(1)
    expect(assigns[:feeds].first).to match(
      count: '21',
      index: 'zero_my_index_name',
      uuid: an_instance_of(String)
    )
  end

  it 'Respect "per" param' do
    get '/feeds?per=5'
    expect(assigns[:total_count]).to eq(21)
    expect(assigns[:feeds].length).to eq(5)
  end

  it 'Respects "page" param' do
    get '/feeds?page=3'
    expect(assigns[:total_count]).to eq(21)
    expect(assigns[:feeds].length).to eq(1)
  end
end
