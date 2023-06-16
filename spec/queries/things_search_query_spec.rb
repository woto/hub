# frozen_string_literal: true

require 'rails_helper'

describe ThingsSearchQuery do
  subject { described_class.call(fragment:, search_string: '', link_url: 'https://link.url/', from: 0, size: 1) }

  let(:texts) do
    [Fragment::Text.new(
      text_start: 'British-based', text_end: '', prefix: 'Jamaican-born and', suffix: 'community leader and'
    )]
  end
  let(:fragment) { Fragment::Struct.new(url: 'https://example.com', texts:) }

  it 'cuts exessive slash at the end of the link url' do
    expect(subject.object).to include(
      body: include(
        query: include(
          bool: include(
            should: include(
              term: include(
                'link_url.keyword': include({ value: 'https://link.url' })
              )
            )
          )
        )
      )
    )
  end
end
