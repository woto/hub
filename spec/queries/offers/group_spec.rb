# frozen_string_literal: true

require 'rails_helper'

describe Offers::Group do

  context 'when `group_by` param is nil' do
    subject do
      Jbuilder.new do |json|
        described_class.call(json: json, group_by: nil, include: nil)
      end.attributes!.deep_symbolize_keys
    end

    it 'returns correct json' do
      expect(subject).to eq({})
    end
  end

  context 'when `include` param is nil' do
    subject do
      Jbuilder.new do |json|
        described_class.call(json: json, group_by: 'group_by', include: nil)
      end.attributes!.deep_symbolize_keys
    end

    it 'does not `include` include param' do
      expect(subject[:aggs][GlobalHelper::GROUP_NAME][:terms]).not_to have_key(:include)
    end
  end

  context 'when `group_by` and `include` params are present' do
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
end
