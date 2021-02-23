# frozen_string_literal: true

require 'rails_helper'

describe Import::DetectFileType do
  subject { described_class.call(feed: feed) }

  context 'when downloaded file does not exist' do
    let(:feed) { create(:feed, :with_attempt_uuid) }

    it 'raises error' do
      expect { subject }.to raise_error(Feeds::Process::DetectFileTypeError, /cannot open/)
    end
  end

  context 'when downloaded xml file exists', :cleanup_feeds do
    let(:feed) { create(:feed, :with_attempt_uuid) }

    it 'stores text/xml file type in `downloaded_file_type`' do
      FileUtils.cp file_fixture('feeds/yml-custom.xml'), feed.file.path
      expect(subject.feed.downloaded_file_type).to eq('text/xml')
      expect(subject).to have_attributes(feed: have_attributes(operation: 'detect_file_type',
                                                               downloaded_file_type: 'text/xml'))
    end
  end

  context 'when downloaded zip file exists', :cleanup_feeds do
    let(:feed) { create(:feed, :with_attempt_uuid) }

    it 'stores application/zip file type in `downloaded_file_type`' do
      FileUtils.cp file_fixture('feeds/YML_sample.xml.zip'), feed.file.path
      expect(subject).to have_attributes(feed: have_attributes(operation: 'detect_file_type',
                                                               downloaded_file_type: 'application/zip'))
    end
  end
end
