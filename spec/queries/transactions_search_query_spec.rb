# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
describe TransactionsSearchQuery do
  subject do
    described_class.call(
      q: nil,
      locale: nil,
      from: from,
      size: size,
      filter_ids: filter_ids,
      sort: sort,
      order: order,
      _source: _source
    )
  end

  let(:from) { Faker::Number.number }
  let(:size) { Faker::Number.number }
  let(:sort) { Faker::Alphanumeric.alphanumeric }
  let(:order) { Faker::Alphanumeric.alphanumeric }
  let(:_source) { Faker::Types.rb_array }

  context 'when filter_ids is nil' do
    let(:filter_ids) { nil }

    it 'builds correct query' do
      expect(subject.object).to eq(
        _source: _source,
        body: {
          sort: {
            sort.to_sym => {
              order: order
            }
          }
        },
        from: from,
        index: Elastic::IndexName.transactions,
        size: size
      )
    end
  end

  # rubocop:disable RSpec/ExampleLength, Metrics/BlockLength
  context 'when filter_ids is an array' do
    let(:filter_ids) { Faker::Types.rb_array }

    it 'builds correct query' do
      expect(subject.object).to eq(
        body: {
          query: {
            bool: {
              must: [
                {
                  bool: {
                    should: [
                      {
                        terms: {
                          credit_id: filter_ids
                        }
                      },
                      {
                        terms: {
                          debit_id: filter_ids
                        }
                      }
                    ]
                  }
                }
              ]
            }
          },
          sort: {
            sort.to_sym => { order: order }
          }
        },
        from: from,
        index: Elastic::IndexName.transactions,
        size: size,
        _source: _source
      )
    end
  end
  # rubocop:enable RSpec/ExampleLength, Metrics/BlockLength
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
