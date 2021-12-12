# frozen_string_literal: true

require 'rails_helper'

describe Import::Offers::Flush do
  subject { described_class.call(offers, advertiser, feed) }

  let(:offer_id) { Faker::Lorem.word }
  let(:offers) { [{ Import::Offers::Hashify::SELF_NAME_KEY => { 'id' => offer_id } }] }
  let(:advertiser) { create(:advertiser) }
  let(:feed) { create(:feed) }

  let(:elastic_client) { object_double(Elasticsearch::Client.new) }

  before do
    allow(GlobalHelper).to receive(:elastic_client).and_return(elastic_client)
  end

  context 'with successful response' do
    it 'calls elastic bulk method with correct arguments' do
      allow(elastic_client).to receive(:bulk).and_return('errors' => false)

      subject

      expect(elastic_client).to have_received(:bulk).with(
        body: [{
          index: {
            _id: "#{offer_id}-#{feed.id}",
            data: {
              Import::Offers::Hashify::SELF_NAME_KEY => {
                'id' => offer_id
              },
              :advertiser_id => advertiser.id,
              :feed_id => feed.id
            }
          }
        }],
        index: Elastic::IndexName.pick('offers').scoped,
        routing: feed.id
      )
    end
  end

  context 'with unsuccessful response' do
    it 'raises error' do
      expect do
        allow(elastic_client).to receive(:bulk).and_return('errors' => true)

        subject

      end.to raise_error Import::Process::ElasticResponseError
    end
  end
end
