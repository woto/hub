# frozen_string_literal: true

require 'rails_helper'

describe Import::Offers::Flush do
  subject { described_class.call(offers, advertiser, feed, client) }

  let(:offer_id) { Faker::Lorem.word }
  let(:offers) { [{ Import::Offers::Hashify::SELF_NAME_KEY => { 'id' => offer_id } }] }
  let(:advertiser) { create(:advertiser) }
  let(:feed) { create(:feed) }
  let(:client) { Elasticsearch::Client.new(Rails.application.config.elastic) }

  context 'with successful response' do
    it 'calls elastic bulk method with correct arguments' do
      expect(client).to receive(:bulk).with(
        body: [{
          index: {
            _id: "#{offer_id}-#{advertiser.id}",
            data: {
              Import::Offers::Hashify::SELF_NAME_KEY => {
                'id' => offer_id
              },
              :advertiser_id => advertiser.id,
              :feed_id => feed.id
            }
          }
        }],
        index: Elastic::IndexName.offers,
        routing: feed.id
      ).and_return('errors' => false)

      subject
    end
  end

  context 'with unsuccessful response' do
    it 'raises error' do
      expect do
        expect(client).to receive(:bulk).and_return('errors' => true)
        subject
      end.to raise_error Feeds::Process::ElasticResponseError
    end
  end
end
