# frozen_string_literal: true

require 'rails_helper'
describe Feeds::Parse do
  subject { described_class.call(feed: feed) }

  let(:feed) { create(:feed, xml_file_path: file_fixture('feeds/yml-simplified.xml')) }

  context 'when xml file has 1 <categories> tag' do
    it 'calls Import::CategoriesCreator#new 1 time' do
      expect(Import::CategoriesCreator).to receive(:new).with(feed: feed).and_call_original
      subject
    end
  end

  context 'when xml file has 1 </categories> tag' do
    let(:categories_creator) { Import::CategoriesCreator.new(feed: feed) }

    it 'calls Import::CategoriesCreator#flush 1 time' do
      allow(Import::CategoriesCreator).to receive(:new).with(feed: feed).and_return(categories_creator)
      expect(categories_creator).to receive(:flush)
      subject
    end
  end

  context 'when xml file has 7 <category> tags' do
    let(:categories_creator) { Import::CategoriesCreator.new(feed: feed) }

    it 'calls Import::CategoriesCreator#append 7 times' do
      expect(Import::CategoriesCreator).to receive(:new).with(feed: feed).and_return(categories_creator)
      expect(categories_creator).to receive(:append).exactly(7).times
      subject
    end
  end

  context 'when xml file has 1 <offers> tag' do
    it 'calls Import::Categories::BindParents.call 1 time' do
      expect(Import::Categories::BindParents).to receive(:call).with(feed: feed)
      subject
    end

    it 'calls Feeds::Offers.new 1 time' do
      expect(Feeds::Offers).to receive(:new).with(feed: feed).and_call_original
      subject
    end
  end

  context 'when xml file has 1 </offers> tag' do
    before { allow(Feeds::Offers).to receive(:new).with(feed: feed).and_return(feeds_offers) }

    let(:feeds_offers) { Feeds::Offers.new(feed: feed) }

    it 'calls Feeds::Offers#flush 1 time' do
      expect(feeds_offers).to receive(:flush)
      subject
    end

    it 'updates feed' do
      freeze_time do
        expect { subject }.to(
          change { feed.reload.operation }.to('success')
                                          .and(change { feed.reload.categories_count }.to(7))
                                          .and(change { feed.reload.offers_count }.to(3))
                                          .and(change { feed.reload.succeeded_at }.to(Time.current))
        )
      end
    end
  end

  context 'when xml file has 3 <offer> tags' do
    before { allow(Feeds::Offers).to receive(:new).with(feed: feed).and_return(feeds_offers) }

    let(:feeds_offers) { Feeds::Offers.new(feed: feed) }

    it 'calls Feeds::Offers#append 3 times' do
      expect(feeds_offers).to receive(:append).exactly(3).times
      subject
    end

    it 'calls Feeds::Offers#flush 1 time' do
      expect(feeds_offers).to receive(:flush)
      subject
    end

    context 'when BULK_THRESHOLD equals to 1' do
      before do
        stub_const('Feeds::Parse::BULK_THRESHOLD', 1)
      end

      it 'calls Feeds::Offers#flush 4 times' do
        expect(feeds_offers).to receive(:flush).and_call_original.exactly(4).times
        subject
      end
    end

    context 'when OFFERS_LIMIT equals to 1' do
      before do
        stub_const('Feeds::Parse::OFFERS_LIMIT', 1)
      end

      it 'raises Import::Process::OffersLimitError' do
        expect { subject }.to(raise_error { Import::Process::OffersLimitError })
      end

      it 'calls Feeds::Offers#append 1 time' do
        expect(feeds_offers).to receive(:append).and_call_original
        expect { subject }.to raise_error(Import::Process::OffersLimitError)
      end

      it 'calls Feeds::Offers#flush 1 time' do
        expect(feeds_offers).to receive(:flush)
        expect { subject }.to raise_error(Import::Process::OffersLimitError)
      end

      it 'updates feed with 1 offer' do
        freeze_time do
          conditions = raise_error(Import::Process::OffersLimitError)
                       .and(change { feed.reload.operation }.to('success'))
                       .and(change { feed.reload.categories_count }.to(7))
                       .and(change { feed.reload.offers_count }.to(1))
                       .and(change { feed.reload.succeeded_at }.to(Time.current))

          expect { subject }.to(conditions)
        end
      end
    end
  end
end
