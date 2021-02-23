# frozen_string_literal: true

require 'rails_helper'

describe Import::Offers::Language do
  subject { described_class.call(params) }

  context 'when description includes russian language' do
    let(:params) { { 'description' => [Feeds::Offers::HASH_BANG_KEY => 'Это длинный текст описания на русском.'] } }

    it 'modifies params with detected language' do
      subject
      expect(params).to include(Import::Offers::Language::LANGUAGE_KEY =>
                                  { name: 'RUSSIAN', code: 'ru', reliable: true })
    end
  end

  context 'when description includes english language' do
    let(:params) { { 'description' => [Feeds::Offers::HASH_BANG_KEY => 'Phrase and clause cover everything.'] } }

    it 'modifies params with detected language' do
      subject
      expect(params).to include(Import::Offers::Language::LANGUAGE_KEY =>
                                  { name: 'ENGLISH', code: 'en', reliable: true })
    end
  end
end
