# frozen_string_literal: true

require 'rails_helper'

# rubocop: disable Metrics/BlockLength
describe OffersSearchQuery do
  subject { described_class.call(args).object }

  let(:from) { 1 }
  let(:size) { 10 }

  let(:args) do
    {
      q: 'q',
      from: from,
      size: size,
      group_by: 'group_by',
      filter_by: 'filter_by',
      filter_id: ['filter_id'],
      include: ['include'],
      languages: ['language']
    }
  end

  specify do
    expect(Offers::Filters).to(
      receive(:call).with(json: anything, filter_by: 'filter_by', filter_id: ['filter_id']).and_call_original
    )

    expect(Offers::Language).to(
      receive(:call).with(json: anything, languages: ['language'])
    )

    expect(Offers::SearchString).to(
      receive(:call).with(json: anything, q: 'q').and_call_original
    )

    expect(Offers::Group).to(
      receive(:call).with(json: anything, group_by: 'group_by', include: ['include']).and_call_original
    )

    expect(subject).to match(
      body: match(
        aggs: include({}),
        query: { bool: include(:filter, :should) }
      ),
      from: from,
      index: Elastic::IndexName.offers,
      size: size
    )
  end
end
# rubocop: enable Metrics/BlockLength
