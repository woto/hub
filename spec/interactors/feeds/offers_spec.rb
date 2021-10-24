# frozen_string_literal: true

require 'rails_helper'

describe Feeds::Offers do
  subject do
    described_class.new(OpenStruct.new(feed: feed))
  end

  let(:doc) { Nokogiri::XML(xml).children.first }
  let(:advertiser) { create(:advertiser) }
  let(:feed) { create(:feed, advertiser: advertiser) }
  let!(:feed_category) { create(:feed_category, feed: feed, ext_id: 'category 1') }

  describe 'special characters' do
    describe 'unquoted tags without CDATA (does not meet standard)' do
      let(:xml) do
        %(
        <offer id="12346">
          <categoryId>category 1</categoryId>
          <name>" & > < '</name>
        </offer>
        )
      end

      specify do
        expect(subject.append(doc).first['name'][0]['#']).to eq('"  >  \'')
      end
    end

    describe 'quoted tags without CDATA' do
      let(:xml) do
        %(
        <offer id="12346">
          <categoryId>category 1</categoryId>
          <name>&quot; &amp; &gt; &lt; &apos;</name>
        </offer>
        )
      end

      specify do
        expect(subject.append(doc).first['name'][0]['#']).to eq('" & > < \'')
      end
    end

    describe 'unsafe tags' do
      let(:xml) do
        %(
        <offer id="12346">
          <categoryId>category 1</categoryId>
          <description>
            <![CDATA[
              test <script>script</script> test
            ]]>
          </description>
        </offer>
        )
      end

      specify do
        expect(subject.append(doc).first['description'][0]['#']).to eq('test script test')
      end
    end

    describe 'stripping leading and trailing spaces' do
      let(:xml) do
        %(
        <offer id="12346">
          <categoryId>category 1</categoryId>
          <description>
            <![CDATA[
              <h3>Мороженица Brand 3811</h3>
              <p>Это...</p>
            ]]>
          </description>
        </offer>
        )
      end

      specify do
        expect(subject.append(doc).first['description'][0]['#']).to eq("Мороженица Brand 3811\n\nЭто...")
      end
    end

    describe 'unsafe characters' do
      # https://yandex.ru/support/marketplace/catalog/yml-requirements.html#requirements
      let(:xml) do
        %(
        <offer id="12346">
          <categoryId>category 1</categoryId>
          <description>
            <![CDATA[ " & > < ' ]]>
          </description>
        </offer>
        )
      end

      specify do
        expect(subject.append(doc).first['description'].first['#']).to eq("\" & > < '")
      end
    end

    describe 'loofah replaces tags with newlines' do
      let(:xml) do
        %(
        <offer id="12346">
          <categoryId>category 1</categoryId>
          <description><![CDATA[<span>one</span> <span>two</span><h1>three</h1><div>four</div>]]></description>
        </offer>
        )
      end

      specify do
        expect(subject.append(doc).first['description'].first['#']).to eq("one two\nthree\n\nfour")
      end
    end
  end

  describe 'minimal xml offer structure' do
    let(:xml) do
      %(
      <offer id="12346">
        <categoryId>category 1</categoryId>
        <description>Отличный подарок для любителей венских вафель.</description>
      </offer>
      )
    end

    describe '#append' do
      it 'calls Import::Offers::Hashify with correct argument' do
        expect(Import::Offers::Hashify).to receive(:call).with(
          doc
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::Customs::Aliexpress' do
        expect(Import::Offers::Customs::Aliexpress).to receive(:call).with(
          instance_of(Hash),
          feed
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::Customs::VendorModel' do
        expect(Import::Offers::Customs::VendorModel).to receive(:call).with(
          instance_of(Hash)
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::Category with correct argument' do
        expect(Import::Offers::Category).to receive(:call).with(
          include('categoryId' => [include('#' => 'category 1')]), feed, FeedCategoriesCache.new(feed)
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::StandardAttributes with correct argument' do
        expect(Import::Offers::StandardAttributes).to receive(:call).with(
          instance_of(Hash),
          feed
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::DetectLanguage with correct argument' do
        expect(Import::Offers::DetectLanguage).to receive(:call).with(
          include('description' => [include('#' => include('Отличный подарок для любителей венских вафель.'))])
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::FavoriteIds with correct arguments' do
        expect(Import::Offers::FavoriteIds).to receive(:call).with(
          include('feed_category_ids' => [feed_category.id]),
          advertiser,
          feed
        ).and_call_original
        subject.append(doc)
      end

      it 'increases total_count' do
        subject.append(doc)
        expect(subject.total_count).to eq(1)
      end

      it 'increases batch_count' do
        subject.append(doc)
        expect(subject.batch_count).to eq(1)
      end

      it 'returns array of offers' do
        freeze_time do
          expect(subject.append(doc)).to eq(
            [
              '*' => { 'id' => '12346' },
              'attempt_uuid' => feed.attempt_uuid,
              'description' => [
                { '#' => 'Отличный подарок для любителей венских вафель.' }
              ],
              'detected_language' => {
                'code' => 'ru',
                'name' => 'RUSSIAN',
                'reliable' => true
              },
              'favorite_ids' => %w[advertiser_id:1 feed_id:1 feed_category_id:1],
              'feed_category_id' => feed_category.id,
              'feed_category_id_0' => feed_category.id,
              'feed_category_ids' => [feed_category.id],
              'indexed_at' => Time.current
            ]
          )
        end
      end
    end

    describe '#flush' do
      it 'calls Import::Offers::Flush with correct arguments' do
        offers = subject.append(doc)
        expect(Import::Offers::Flush).to receive(:call).with(
          offers,
          advertiser,
          feed
        ).and_call_original
        subject.flush
      end

      it 'zerofy batch_count' do
        subject.append(doc)
        expect(subject.batch_count).to eq(1)
        subject.flush
        expect(subject.batch_count).to eq(0)
      end

      it 'does not zerofy total_count' do
        subject.append(doc)
        subject.flush
        expect(subject.total_count).to eq(1)
      end
    end
  end
end
