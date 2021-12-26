# frozen_string_literal: true

require 'rails_helper'

describe Extractors::Iframely do
  it 'proxies request to iframely.com' do
    stub_request(:get, 'https://iframe.ly/api/iframely?api_key=iframely_key_value&url=https://example.com')
      .to_return(status: 200, body: { a: 'b' }.to_json, headers: {})
    described_class.call(url: 'https://example.com')
  end
end
