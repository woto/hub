# frozen_string_literal: true

require 'rails_helper'

describe Feeds::OffersInteractor do
  subject do
    described_class.new(OpenStruct.new(feed: feed))
  end

  let(:doc) { Nokogiri::XML(xml).children.first }
  let(:advertiser) { create(:advertiser) }
  let(:feed) { create(:feed, advertiser: advertiser) }
  let!(:feed_category) { create(:feed_category, feed: feed, ext_id: 'category 1') }

  describe 'FloryDay (does not meet standard)' do
    let(:xml) do
      %(
      <offer available="true" id="FDcDEldeg5727985" type="vendor.model">
        <categoryId>164</categoryId>
        <currencyId>EUR</currencyId>
        <description>Lässige Kleidung Polyester V-Ausschnitt Lange Ärmel Grau Geometrisch Blusen im H-Linien-Schnitt Normal
          Knöpfe Stück S M L XL XXL Blusen
        </description>
        <modified_time>1635027334</modified_time>
        <name>Lange Ärmel Geometrisch V-Ausschnitt Blusen (1645727985)</name>
        <old_price>30.02</old_price>
        <param name="color">Gray</param>
        <param name="size">S,M,L,XL,XXL</param>
        <picture>http://d3sej37t1mx5mv.cloudfront.net/image/600_600/ed/d6/edd6d0aa19581b22d7389c570f6d719b.jpg</picture>
        <price>17.66</price>
        <typePrefix>Apparel &amp; Accessories &gt; Clothing</typePrefix>
        <url>https://example.com</url>
        <vendor>FloryDay</vendor>
      </offer>
      )
    end

    specify do
      expect(subject.append(doc).first['name'][0]['#']).to eq('Lange Ärmel Geometrisch V-Ausschnitt Blusen (1645727985)')
    end
  end

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
        expect(Import::Offers::HashifyInteractor).to receive(:call).with(
          doc
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::Customs::Aliexpress' do
        expect(Import::Offers::Customs::AliexpressInteractor).to receive(:call).with(
          instance_of(Hash),
          feed
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::Customs::VendorModelInteractor' do
        expect(Import::Offers::Customs::VendorModelInteractor).to receive(:call).with(
          instance_of(Hash)
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::CategoryInteractor with correct argument' do
        expect(Import::Offers::CategoryInteractor).to receive(:call).with(
          include('categoryId' => [include('#' => 'category 1')]), feed, FeedCategoriesCache.new(feed)
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::StandardAttributesInteractor with correct argument' do
        expect(Import::Offers::StandardAttributesInteractor).to receive(:call).with(
          instance_of(Hash),
          feed
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::DetectLanguageInteractor with correct argument' do
        expect(Import::Offers::DetectLanguageInteractor).to receive(:call).with(
          include('description' => [include('#' => include('Отличный подарок для любителей венских вафель.'))])
        ).and_call_original
        subject.append(doc)
      end

      it 'calls Import::Offers::FavoriteIdsInteractor with correct arguments' do
        expect(Import::Offers::FavoriteIdsInteractor).to receive(:call).with(
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
        expect(Import::Offers::FlushInteractor).to receive(:call).with(
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
