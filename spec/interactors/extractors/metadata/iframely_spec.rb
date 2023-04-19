# frozen_string_literal: true

require 'rails_helper'

describe Extractors::Metadata::Iframely do
  it 'proxies request to iframely' do
    # stub_request(:get, 'https://iframe.ly/api/iframely?api_key=iframely_key_value&url=https://example.com')
    stub_request(:get, 'http://iframely:8061/iframely?url=https://example.com')
      .to_return(status: 200, body: { a: 'b' }.to_json, headers: { 'Content-Type' => 'application/json' })
    result = described_class.call(url: 'https://example.com').object
    expect(result).to eq({ 'a' => 'b' })
  end
end
