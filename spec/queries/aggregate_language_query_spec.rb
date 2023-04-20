# frozen_string_literal: true

require 'rails_helper'

describe AggregateLanguageQuery do
  subject { described_class.call(params) }

  let(:feed) { create(:feed) }

  context 'when params are valid' do
    let(:params) { { feed: } }

    it 'builds correct query' do
      expect(subject).to have_attributes(
        object: {
          body: {
            query: {
              bool: {
                filter: [
                  { term: { feed_id: feed.id } }
                  # { "term": { "detected_language.reliable": true } }
                ]
              }
            },
            aggs: {
              group: {
                terms: {
                  field: "#{Import::Offers::DetectLanguage::LANGUAGE_KEY}.code.keyword",
                  size: 1
                }
              }
            }
          },
          index: Elastic::IndexName.pick('offers').scoped,
          routing: feed.id,
          size: 0
        }
      )
    end
  end

  context 'when params are invalid' do
    let(:params) { {} }

    it 'raises error' do
      expect { subject }.to raise_error(StandardError, { feed: ['is missing'] }.to_json)
    end
  end
end
