# frozen_string_literal: true

require 'rails_helper'

describe Offers::Group do
  context 'when `include` param is present' do
    subject do
      Jbuilder.new do |json|
        described_class.call(json: json, group_by: 'group_by', include: ['include'])
      end.attributes!.deep_symbolize_keys
    end

    it 'returns correct json' do
      expect(subject).to eq(
        aggs: {
          GlobalHelper::GROUP_NAME => {
            terms: {
              field: 'group_by',
              order: { "sort.sum_of_squares": 'desc' },
              size: GlobalHelper::GROUP_LIMIT,
              include: ['include']
            },
            aggs: {
              offers: {
                top_hits: {
                  size: GlobalHelper::MULTIPLICATOR - 1
                }
              },
              sort: {
                extended_stats: {
                  script: {
                    source: '_score'
                  }
                }
              }
            }
          }
        }
      )
    end
  end

  context 'when `include` param is not present' do
    subject do
      Jbuilder.new do |json|
        described_class.call(json: json, group_by: 'group_by')
      end.attributes!.deep_symbolize_keys
    end

    it 'returns correct json' do
      expect(subject).to eq(
        aggs: {
          GlobalHelper::GROUP_NAME => {
            terms: {
              field: 'group_by',
              order: { "sort.sum_of_squares": 'desc' },
              size: GlobalHelper::GROUP_LIMIT
            },
            aggs: {
              offers: {
                top_hits: {
                  size: GlobalHelper::MULTIPLICATOR - 1
                }
              },
              sort: {
                extended_stats: {
                  script: {
                    source: '_score'
                  }
                }
              }
            }
          }
        }
      )
    end
  end
end
