# frozen_string_literal: true

require 'rails_helper'

describe BoostIndexingInteractor do
  it 'runs all the indexing boosters' do
    expect(Indexing::YandexJob).to receive(:perform_later).with(url: 'https://example.com')
    expect(Indexing::GoogleJob).to receive(:perform_later).with(url: 'https://example.com')
    expect(Indexing::BingJob).to receive(:perform_later).with(url: 'https://example.com')
    described_class.call(url: 'https://example.com')
  end
end
