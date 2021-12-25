# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Indexing::GoogleJob, type: :job do
  subject { described_class.perform_now(url: 'http://example.com') }

  it 'works' do
    stub_request(:post, 'https://www.googleapis.com/oauth2/v4/token')
      .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

    stub_request(:post, 'https://indexing.googleapis.com/v3/urlNotifications:publish')
      .with(body: { 'type' => 'URL_UPDATED', 'url' => 'http://example.com' }.to_json)
      .to_return(status: 200, body: '', headers: {})
    subject
  end

  context 'when authorization failed' do
    it 'raises exception' do
      stub_request(:post, 'https://www.googleapis.com/oauth2/v4/token')
        .to_return(status: 400, body: '', headers: { 'Content-Type' => 'application/json' })

      expect { subject }.to raise_exception(Signet::AuthorizationError)
    end
  end

  context 'when publishing fails' do
    it 'raises exception' do
      stub_request(:post, 'https://www.googleapis.com/oauth2/v4/token')
        .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

      stub_request(:post, 'https://indexing.googleapis.com/v3/urlNotifications:publish')
        .with(body: { 'type' => 'URL_UPDATED', 'url' => 'http://example.com' }.to_json)
        .to_return(status: 400, body: '', headers: {})

      expect { subject }.to raise_exception(Google::Apis::ClientError)
    end
  end
end
