# frozen_string_literal: true

require 'rails_helper'

describe Import::Preprocess do
  subject { described_class.call(params) }

  context 'when downloaded_file_type is empty' do
    let(:feed) { create(:feed, downloaded_file_type: nil) }
    let(:params) { { feed: feed } }

    it 'raises error' do
      expect { subject }.to raise_error(Feeds::Process::UnknownFileType)
    end
  end

  context 'when downloaded_file_type is xml' do
    let(:feed) { create(:feed, downloaded_file_type: ' xml ') }
    let(:params) { { feed: feed } }

    it 'simply copies file.path to xml_file path' do
      expect(subject).to have_attributes(feed: have_attributes(operation: 'preprocess',
                                                               xml_file_path: feed.file.path))
    end
  end

  context 'when downloaded_file_type is not a zip' do
    let(:feed) { create(:feed, downloaded_file_type: 'some file type') }
    let(:params) { { feed: feed } }

    it 'simply copies file.path to xml_file path' do
      expect(subject).to have_attributes(feed: have_attributes(operation: 'preprocess',
                                                               xml_file_path: feed.file.path))
    end
  end

  context 'when downloaded_file_type is zip' do
    let(:feed) do
      create(:feed, downloaded_file_type: 'some-zip-file',
                    with_downloaded_file: file_fixture('feeds/YML_sample.zip'))
    end
    let(:params) { { feed: feed } }

    it 'unpacks zip and copies the only one file to xml_file path' do
      expect(subject).to have_attributes(feed: have_attributes(operation: 'preprocess',
                                                               xml_file_path: end_with('YML_sample.xml')))
      expect(Pathname.new(feed.xml_file_path)).to be_file
      expect(Pathname.new(feed.file.path)).to be_file
      expect(Pathname.new(feed.file.dir)).to be_directory
    end
  end

  context 'when downloaded_file_type is zip but file is "corrupted"' do
    let(:feed) do
      create(:feed, downloaded_file_type: 'zip',
                    with_downloaded_file: file_fixture('feeds/YML_sample.xml'))
    end
    let(:params) { { feed: feed } }

    it 'fails with "End-of-central-directory signature not found" error' do
      expect { subject }.to raise_error(Feeds::Process::UnzipError, /End-of-central-directory signature not found/)
    end
  end

  context 'when downloaded_file_type is zip but archive has more than one file inside it' do
    let(:feed) do
      create(:feed, downloaded_file_type: 'zip',
                    with_downloaded_file: file_fixture('feeds/wrong_content.zip'))
    end
    let(:params) { { feed: feed } }

    it 'fails with "Wrong number of unpacked files" error' do
      expect { subject }.to raise_error(Feeds::Process::UnzipError, 'Wrong number of unpacked files')
    end
  end
end
