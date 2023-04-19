# frozen_string_literal: true

require 'rails_helper'

describe Extractors::NpmjsCom::Suggestions do
  it 'proxies request to npmjs' do
    stub_request(:get, 'https://www.npmjs.com/search/suggestions?q=foo&size=20')
      .to_return(status: 200, body: { a: 'b' }.to_json, headers: { 'Content-Type' => 'application/json' })
    result = described_class.call(q: 'foo').object
    expect(result).to eq({ 'a' => 'b' })
  end
end
