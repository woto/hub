# frozen_string_literal: true

require 'rails_helper'

describe Offers::Filters do
  subject do
    Jbuilder.new do |json|
      described_class.call(json: json, filter_by: 'filter_by', filter_id: ['filter_id'])
    end.attributes!.deep_symbolize_keys
  end

  it 'returns correct json' do
    expect(subject).to eq({ "filter": [{ "terms": { "filter_by": ['filter_id'] } }] })
  end
end
