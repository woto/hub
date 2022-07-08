# frozen_string_literal: true

require 'rails_helper'

describe Fragment::Parser do
  context 'when fragment url includes multiple fragments' do
    let(:fragment_url) do
      'http://foo.com?bar/#:~:text=This%20domain,examples&text=in%20literature&text=More%20information...'
    end

    it 'returns correct array of fragment structs' do
      texts = [Fragment::Text.new(prefix: '', suffix: '', text_start: 'This domain', text_end: 'examples'),
               Fragment::Text.new(prefix: '', suffix: '', text_start: 'in literature', text_end: ''),
               Fragment::Text.new(prefix: '', suffix: '', text_start: 'More information...', text_end: '')]
      fragment_struct = Fragment::Struct.new(url: 'http://foo.com?bar/', texts: texts)
      expect(described_class.call(fragment_url: fragment_url)).to eq(fragment_struct)
    end
  end

  context 'when fragment consist of text_start and prefix + suffix' do
    let(:fragment_url) do
      'https://en.wikipedia.org/wiki/Main_Page#:~:text=Jamaican%2Dborn%20and-,British%2Dbased,-community%20leader%20and'
    end

    it 'returns correct fragment struct' do
      texts = [Fragment::Text.new(text_start: 'British-based', text_end: '',
                                  prefix: 'Jamaican-born and', suffix: 'community leader and')]
      fragment_struct = Fragment::Struct.new(url: 'https://en.wikipedia.org/wiki/Main_Page', texts: texts)

      expect(described_class.call(fragment_url: fragment_url)).to(eq(fragment_struct))
    end
  end
end
