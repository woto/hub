# frozen_string_literal: true

require 'rails_helper'

describe Import::AggregateLanguage do
  subject { described_class.call(params) }

  let(:feed) { create(:feed) }

  context 'with valid params' do
    let(:params) { { feed: feed } }

    before do
      create(:offer, feed_id: feed.id, Import::Offers::DetectLanguage::LANGUAGE_KEY => { name: 'RUSSIAN' })
      create(:offer, feed_id: feed.id, Import::Offers::DetectLanguage::LANGUAGE_KEY => { name: 'RUSSIAN' })
      create(:offer, feed_id: feed.id, Import::Offers::DetectLanguage::LANGUAGE_KEY => { name: 'ENGLISH' })
    end

    it 'calls AggregateLanguageQuery.call' do
      expect(feed).to have_attributes(language: nil)
      expect(AggregateLanguageQuery).to receive(:call).and_call_original
      subject
      expect(feed).to have_attributes(language: 'RUSSIAN')
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
    let(:params) { { feed: feed, a: 'b' } }

    it 'raises error' do
      expect { subject }.to raise_error
    end
  end
end
