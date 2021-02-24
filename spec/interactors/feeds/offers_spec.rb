# frozen_string_literal: true

require 'rails_helper'

describe Feeds::Offers do
  subject do
    instance = described_class.new(OpenStruct.new(feed: feed))
    instance.append(doc)
  end

  let(:doc) do
    Nokogiri::XML(xml).children.first
  end

  let(:advertiser) { create(:advertiser) }
  let(:feed) { create(:feed, advertiser: advertiser) }

  describe 'minimal xml offer structure' do

    let(:xml) do
      %(
      <offer id="12346">
        <categoryId>category 1</categoryId>
        <description>Отличный подарок для любителей венских вафель.</description></root>
      </offer>
      )
    end

    let!(:feed_category) { create(:feed_category, feed: feed, ext_id: 'category 1') }

    it 'calls Import::Offers::Language with correct argument' do
      expect(Import::Offers::Language).to receive(:call).with(
        include('description' => [include('#' => include('Отличный подарок для любителей венских вафель.'))])
      )
      subject
    end

    it 'calls Import::Offers::Category with correct argument' do
      expect(Import::Offers::Category).to receive(:call).with(
        include('categoryId' => [include('#' => 'category 1')]), feed, feed.feed_categories_for_import
      )
      subject
    end

    it 'calls Import::Offers::FavoriteIds with correct arguments' do
      expect(Import::Offers::FavoriteIds).to receive(:call).with(
        include('feed_category_ids' => [feed_category.id]), advertiser, feed
      )
      subject
    end
  end
end
