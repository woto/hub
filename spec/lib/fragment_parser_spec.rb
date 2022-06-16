# frozen_string_literal: true

require 'rails_helper'

describe FragmentParser do
  context 'when fragment url includes multiple fragments' do
    let(:fragment_url) { 'http://foo.com?bar/#:~:text=This%20domain,examples&text=in%20literature&text=More%20information...' }

    it 'returns correct array of fragment structs' do
      fragment_struct1 = FragmentStruct.new(location_url: 'http://foo.com?bar/', prefix: '', suffix: '',
                                            text_start: 'This domain', text_end: 'examples')
      fragment_struct2 = FragmentStruct.new(location_url: 'http://foo.com?bar/', prefix: '', suffix: '',
                                            text_start: 'in literature', text_end: '')
      fragment_struct3 = FragmentStruct.new(location_url: 'http://foo.com?bar/', prefix: '', suffix: '',
                                            text_start: 'More information...', text_end: '')

      expect(described_class.call(fragment_url: fragment_url)).to(
        contain_exactly(fragment_struct1, fragment_struct2, fragment_struct3)
      )
    end
  end

  context 'when fragment consist of text_start and prefix + suffix' do
    let(:fragment_url) do
      'https://en.wikipedia.org/wiki/Main_Page#:~:text=Jamaican%2Dborn%20and-,British%2Dbased,-community%20leader%20and'
    end

    it 'returns correct fragment struct' do
      fragment_struct = FragmentStruct.new(
        location_url: 'https://en.wikipedia.org/wiki/Main_Page', text_start: 'British-based', text_end: '',
        prefix: 'Jamaican-born and', suffix: 'community leader and'
      )

      expect(described_class.call(fragment_url: fragment_url)).to(contain_exactly(fragment_struct))
    end
  end
end
