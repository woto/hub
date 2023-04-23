# frozen_string_literal: true

require 'rails_helper'

describe Import::ProcessInteractor do
  subject { described_class.call(params) }

  describe 'simple success flow' do
    let(:feed) { create(:feed, url: 'http://www.example.com/price.yml') }
    let(:params) { { feed: feed } }

    before do
      stub_request(:any, 'http://www.example.com/price.yml')
        .to_return(body: file_fixture('feeds/yml-simplified.xml'), status: 200)
    end

    it 'calls nested interactors with correct arguments' do
      expect(Import::LockFeedInteractor).to receive(:call).with(feed: feed).and_call_original
      expect(Import::DownloadFeedInteractor).to receive(:call).with(feed: feed)
      expect(Import::DetectFileTypeInteractor).to receive(:call).with(feed: feed)
      expect(Import::PreprocessInteractor).to receive(:call).with(feed: feed)
      expect(Feeds::ParseInteractor).to receive(:call).with(feed: feed)
      expect(Import::DeleteOldOffersInteractor).to receive(:call).with(feed: feed)
      expect(Import::ReleaseFeedInteractor).to receive(:call).with(feed: feed, error: nil)
      expect(Elastic::RefreshOffersIndexInteractor).to receive(:call).with(no_args)
      expect(Import::AggregateLanguageInteractor).to receive(:call).with(feed: feed)
      subject
    end
  end
end
