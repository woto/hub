# frozen_string_literal: true

require 'rails_helper'

describe AggregateLanguageQuery do
  subject { described_class.call(params) }

  let(:feed) { create(:feed) }

  context 'when params are valid' do
    let(:params) { { feed: feed } }

    it 'works' do
      expect(subject).to have_attributes(
        object: {
          body: {
            "query": {
              "term": {
                "feed_id": {
                  "value": feed.id
                }
              }
            },
            "aggs": {
              "group": {
                "terms": {
                  "field": "#{Import::Offers::DetectLanguage::LANGUAGE_KEY}.name.keyword",
                  "size": 1
                }
              }
            }
          }.to_json,
          index: Elastic::IndexName.offers,
          routing: feed.id,
          size: 0
        }
      )
    end
  end

  context 'when params are invalid' do
    let(:params) { {} }

    it 'works' do
      expect { subject }.to raise_error
    end
  end
end
