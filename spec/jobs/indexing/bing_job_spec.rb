# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Indexing::BingJob, type: :job do
  subject { described_class.perform_now(url: 'http://example.com') }

  it 'successfully finishes when 200 response code' do
    url = 'https://www.bing.com/indexnow?key=index_now_key_value&keyLocation=https://goodreviews.ru/index_now_key_value&url=http://example.com'
    stub_request(:get, url).to_return(status: 200)

    subject
  end

  it 'raises error when 422 response code' do
    url = 'https://www.bing.com/indexnow?key=index_now_key_value&keyLocation=https://goodreviews.ru/index_now_key_value&url=http://example.com'
    stub_request(:get, url).to_return(status: 422)

    expect { subject }.to raise_exception(Faraday::UnprocessableEntityError)
  end
end
