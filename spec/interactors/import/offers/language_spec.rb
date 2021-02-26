# frozen_string_literal: true

require 'rails_helper'

describe Import::Offers::Language do
  subject { described_class.call(offer) }

  context 'when description includes russian language' do
    let(:offer) { { 'description' => [Import::Offers::Hashify::HASH_BANG_KEY => 'Это длинный текст описания на русском.'] } }

    it 'modifies offer with detected language' do
      subject
      expect(offer).to include(Import::Offers::Language::LANGUAGE_KEY =>
                                  { 'name' => 'RUSSIAN', 'code' => 'ru', 'reliable' => true })
    end
  end

  context 'when description includes english language' do
    let(:offer) { { 'description' => [Import::Offers::Hashify::HASH_BANG_KEY => 'Phrase and clause cover everything.'] } }

    it 'modifies offer with detected language' do
      subject
      expect(offer).to include(Import::Offers::Language::LANGUAGE_KEY =>
                                  { 'name' => 'ENGLISH', 'code' => 'en', 'reliable' => true })
    end
  end

  context 'when name and description are empty' do
    let(:offer) { { 'description' => [Import::Offers::Hashify::HASH_BANG_KEY => ''] } }

    it 'detects unknown langugage and stores results in offer' do
      subject
      expect(offer).to include(Import::Offers::Language::LANGUAGE_KEY =>
                                  { 'name' => 'Unknown', 'code' => 'un', 'reliable' => true })
    end
  end
end
