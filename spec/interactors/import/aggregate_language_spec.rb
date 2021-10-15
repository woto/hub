# frozen_string_literal: true

require 'rails_helper'

describe Import::AggregateLanguage do
  subject { described_class.call(params) }

  let(:feed_category) { create(:feed_category) }

  context 'with valid params' do
    let(:params) { { feed: feed_category.feed } }

    before do
      OfferCreator.call(feed_category: feed_category, name: 'Название товара на русском языке',
                        description: 'Длинный текст чтобы язык был надежно определен')
      OfferCreator.call(feed_category: feed_category, name: 'Название товара на русском языке',
                        description: 'Длинный текст чтобы язык был надежно определен')
      OfferCreator.call(feed_category: feed_category, name: 'Product name in English language',
                        description: 'Long text so that the language is reliably determined')
      OfferCreator.call(feed_category: feed_category, name: 'Не надежно', description: 'Not reliable')
    end

    it 'calls AggregateLanguageQuery.call and sets feed language' do
      expect(AggregateLanguageQuery).to receive(:call).and_call_original
      subject
      expect(feed_category.feed).to have_attributes(languages: { 'en' => 1, 'ru' => 2 })
    end
  end

  context 'with nil feed param' do
    let(:params) { { feed: nil } }

    it 'does not raise error' do
      expect(AggregateLanguageQuery).not_to receive(:call)
      expect { subject }.not_to raise_error
    end
  end

  context 'with missed feed param' do
    let(:params) { {} }

    it 'raises error' do
      expect { subject }.to raise_error
    end
  end

  context 'with extra param' do
    let(:params) { { feed: feed_category.feed, a: 'b' } }

    it 'raises error' do
      expect { subject }.to raise_error
    end
  end
end
