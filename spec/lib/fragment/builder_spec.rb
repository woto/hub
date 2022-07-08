# frozen_string_literal: true

require 'rails_helper'

describe Fragment::Builder do
  context 'with text_start and text' do
    it 'builds correct url' do
      expect(
        described_class.call(url: 'https://ya.ru', text_start: 'text_start', prefix: '', suffix: nil,
                             text_end: 'text_end')
      ).to eq('https://ya.ru#:~:text=text_start,text_end')
    end
  end

  context 'with prefix, text_start and text_end' do
    it 'builds correct url' do
      expect(described_class.call(url: 'https://ya.ru/', prefix: 'prefix', text_start: 'text_start', suffix: 'suffix'))
        .to eq('https://ya.ru/#:~:text=prefix-,text_start,-suffix')
    end
  end

  context 'with empty args (for example was clicked image or icon)' do
    it 'returns url as is' do
      expect(described_class.call(url: 'https://ya.ru')).to eq('https://ya.ru')
    end
  end
end
