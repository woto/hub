# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mentions::IframelyJob, type: :job do
  subject { described_class.perform_now(mention_id: mention.id, mention_url: mention.url) }

  let(:mention) { create(:mention, url: 'https://example.com/?fake') }

  context 'when 200 response code' do
    it 'successfully stores title and canonical_url' do
      url = 'http://iframely:8061/iframely?url=https://example.com/?fake'
      stub_request(:get, url).to_return(
        status: 200,
        body: { meta: { canonical: 'https://example.com', title: 'Example' }}.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

      subject

      expect(mention.reload).to have_attributes(title: 'Example', canonical_url: 'https://example.com')
    end
  end

  context 'when 403 response code' do
    it 'raises exception' do
      url = 'http://iframely:8061/iframely?url=https://example.com/?fake'
      stub_request(:get, url).to_return(status: 403)

      expect { subject }.to raise_exception(RuntimeError, 'the server responded with status 403')
    end
  end
end
