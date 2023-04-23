# frozen_string_literal: true

require 'rails_helper'

describe Offers::SearchString do
  context 'when `q` param is nil' do
    subject do
      Jbuilder.new do |json|
        described_class.call(json: json, q: nil)
      end.attributes!.deep_symbolize_keys
    end

    it 'returns correct json' do
      expect(subject).to eq({})
    end
  end

  context 'when `q` param is present' do
    subject do
      Jbuilder.new do |json|
        described_class.call(json: json, q: 'This is an english sentence. А это предложение на русском языке.')
      end.attributes!.deep_symbolize_keys
    end

    it 'returns correct json' do
      expect(subject).to eq(
        filter: [
          {
            multi_match: {
              fields: %W[
                name.#{Import::Offers::HashifyInteractor::HASH_BANG_KEY}
                feed_category_name
                description.#{Import::Offers::HashifyInteractor::HASH_BANG_KEY}
              ],
              fuzziness: 'auto',
              minimum_should_match: 6,
              query: 'english sentence это предложение русском языке'
            }
          }
        ],
        should: [
          {
            multi_match: {
              fields: %W[
                name.#{Import::Offers::HashifyInteractor::HASH_BANG_KEY}^30
                feed_category_name
                description.#{Import::Offers::HashifyInteractor::HASH_BANG_KEY}
              ],
              query: 'english sentence это предложение русском языке'
            }
          }
        ]
      )
    end
  end
end
