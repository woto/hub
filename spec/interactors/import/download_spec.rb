# frozen_string_literal: true

require 'rails_helper'

describe Import::Download, :cleanup_feeds do
  subject { described_class.call(feed: feed) }

  let(:feed) { create(:feed, url: 'http://example.com') }

  context 'when tests includes :cleanup_feeds' do
    it 'cleanups feeds_path' do
      expect(Dir[Rails.root.join(Rails.configuration.feeds_path, '*')]).to eq([])
    end
  end

  describe 'update feed with `downloaded_file_size` and `operation`' do
    it { expect(feed.operation).not_to eq('downloaded_file_size') }
    it { expect(feed.downloaded_file_size).not_to eq(3) }
    it 'stores file size and operation type in Feed' do
      stub_request(:get, 'http://example.com/').to_return(status: 200, body: '123')
      subject
      expect(feed.operation).to eq('downloaded_file_size')
      expect(feed.downloaded_file_size).to eq(3)
    end
  end

  context 'when respond successfully' do
    it 'stores file' do
      stub_request(:get, 'http://example.com/').to_return(status: 200, body: '123')
      subject
      expect(Pathname.new(feed.file.path)).to be_file
      expect(File.read(feed.file.path)).to eq('123')
    end
  end

  context 'when got Net::HTTPServerException' do
    it 'raises Feeds::Process::HTTPServerException' do
      stub_request(:get, 'http://example.com').to_raise(Net::HTTPServerException.new('', :net_http_not_found))
      expect { subject }.to raise_error(Feeds::Process::HTTPServerException)
    end
  end

  context 'when got Net::ReadTimeout' do
    it 'raises Feeds::Process::ReadTimeout' do
      stub_request(:get, 'http://example.com').to_raise(Net::ReadTimeout)
      expect { subject }.to raise_error(Feeds::Process::ReadTimeout)
    end
  end
end
