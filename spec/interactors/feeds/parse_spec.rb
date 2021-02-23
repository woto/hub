# frozen_string_literal: true

require 'rails_helper'

describe Feeds::Parse do
  let(:feed) { create(:feed, :with_attempt_uuid, xml_file_path: file_fixture('feeds/yml-simplified.xml')) }

  it 'does not raise error' do
    described_class.call(feed: feed)
  end

  # TODO: better place for this code is interactors/feeds/offers_spec.rb
  describe 'Import::Offers::Language' do
    let(:feed) do
      create(:feed, :with_attempt_uuid, xml_file_path: file_fixture('feeds/feed_with_different_languages.xml'))
    end

    it 'calls Import::Offers::Language.call twice' do
      expect(Import::Offers::Language).to receive(:call).with(
        include(
          'description' => [include('#' => include('Отличный подарок для любителей венских вафель.'))]))
      expect(Import::Offers::Language).to receive(:call).with(
        include('description' => [include('#' => include('Ice cream maker Brand 3811'))]))
      described_class.call(feed: feed)
    end
  end
end
