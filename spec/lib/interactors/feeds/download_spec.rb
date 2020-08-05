# frozen_string_literal: true

require 'rails_helper'

describe Feeds::Download, :cleanup_feeds do
  subject { described_class.call(feed: feed) }
  let(:feed) { create(:feed, url: 'http://example.com') }

  context 'when tests includes :cleanup_feeds' do
    it 'cleanups feeds_path' do
      expect(Dir[Rails.root.join(Rails.configuration.feeds_path, '*')]).to eq([])
    end
  end

  context 'when respond successfully' do
    it 'stores file' do
      stub_request(:get, 'http://example.com/').to_return(status: 200, body: '123')
      subject
      expect(File.file?(feed.file_full_path)).to be_truthy
      expect(File.read(feed.file_full_path)).to eq('123')
    end
  end

  context 'when got Net::HTTPServerException' do
    it 'raises Feeds::Process::FeedDisabledError' do
      stub_request(:get, 'http://example.com').to_raise(Net::HTTPServerException.new("", :net_http_not_found))
      expect { subject }.to raise_error(Feeds::Process::FeedDisabledError)
    end
  end

  context 'when got Net::ReadTimeout' do
    it 'raises Feeds::Process::FeedDisabledError' do
      stub_request(:get, 'http://example.com').to_raise(Net::ReadTimeout)
      expect { subject }.to raise_error(Feeds::Process::TimeoutError)
    end
  end
end
