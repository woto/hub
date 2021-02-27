# frozen_string_literal: true

require 'rails_helper'

describe Feeds::Process do
  subject { described_class.call(params) }

  describe 'simple success flow' do
    let(:feed) { create(:feed, url: 'http://www.example.com/price.yml') }
    let(:params) { { feed: feed } }

    before do
      stub_request(:any, 'http://www.example.com/price.yml')
        .to_return(body: file_fixture('feeds/yml-simplified.xml'), status: 200)
    end

    it 'calls nested interactors with correct arguments' do
      expect(Feeds::PickJob).to receive(:call).with(feed: feed).and_call_original
      expect(Import::DownloadFeed).to receive(:call).with(feed: feed)
      expect(Import::DetectFileType).to receive(:call).with(feed: feed)
      expect(Import::Preprocess).to receive(:call).with(feed: feed)
      expect(Feeds::Parse).to receive(:call).with(feed: feed)
      expect(Offers::Delete).to receive(:call).with(feed: feed, error: nil)
      expect(Feeds::ReleaseJob).to receive(:call).with(feed: feed, error: nil)
      expect(Elastic::RefreshOffersIndex).to receive(:call).with(no_args)
      expect(Import::AggregateLanguage).to receive(:call).with(feed: feed)
      subject
    end
  end
end
