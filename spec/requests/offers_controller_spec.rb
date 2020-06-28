require 'rails_helper'

describe OffersController do
  before(:all) do
    Staff::Cropper::Elastic.crop
    Staff::Seeder::Elastic.pagination
  end

  context 'without feed' do
    it 'Searches by name' do
      get '/offers?q=one_my_offer_name'
      expect(assigns[:total_count]).to eq(1)

      expect(assigns[:offers].length).to eq(1)
      expect(assigns[:offers].first).to include(
        '_index' => ::Elastic::IndexName.offers('zero_my_index_name'),
        '_type' => '_doc',
        '_id' => '22'
      )
      expect(assigns[:offers].first['_source']).to match(
        'name' => '[one] [my_offer_name] one_my_offer_name',
        'price' => an_instance_of(Float),
        'currencyId' => an_instance_of(String),
        'url' => an_instance_of(String),
        'picture' => an_instance_of(Array)
      )
    end

    it 'Respect "per" param' do
      get '/offers?per=5'
      expect(assigns[:total_count]).to eq(41)
      expect(assigns[:offers].length).to eq(5)
    end

    it 'Respects "page" param' do
      get '/offers?page=5'
      expect(assigns[:total_count]).to eq(41)
      expect(assigns[:offers].length).to eq(1)
    end
  end

  context 'with feed' do
    it 'Searches by name' do
      get '/feeds/zero_my_index_name/offers?q=one_my_offer_name'
      expect(assigns[:total_count]).to eq(1)

      expect(assigns[:offers].length).to eq(1)
      expect(assigns[:offers].first).to include(
        '_index' => ::Elastic::IndexName.offers('zero_my_index_name'),
        '_type' => '_doc',
        '_id' => '22'
      )
      expect(assigns[:offers].first['_source']).to match(
        'name' => '[one] [my_offer_name] one_my_offer_name',
        'price' => an_instance_of(Float),
        'currencyId' => an_instance_of(String),
        'url' => an_instance_of(String),
        'picture' => an_instance_of(Array)
      )
    end

    it 'Respect "per" param' do
      get '/feeds/zero_my_index_name/offers?per=5'
      expect(assigns[:total_count]).to eq(21)
      expect(assigns[:offers].length).to eq(5)
    end

    it 'Respects "page" param' do
      get '/feeds/zero_my_index_name/offers?page=3'
      expect(assigns[:total_count]).to eq(21)
      expect(assigns[:offers].length).to eq(1)
    end

  end
end
