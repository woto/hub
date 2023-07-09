# frozen_string_literal: true

require 'rails_helper'

describe Extractors::YoutubeCom::GetChannelIdFromUrlInteractor do
  context 'with @adnantoky' do
    subject { described_class.call(url: 'https://www.youtube.com/@adnantoky') }

    before do
      stub_request(:get, 'https://www.youtube.com/@adnantoky')
        .to_return(status: 200, body: '... channel_id=UCUZWSD1JrY7ZEXpKmcSygiA ...', headers: {})
    end

    it { is_expected.to have_attributes(object: 'UCUZWSD1JrY7ZEXpKmcSygiA') }
  end

  context 'with /user/LinusTechTips' do
    subject { described_class.call(url: 'https://www.youtube.com/user/LinusTechTips') }

    before do
      stub_request(:get, 'https://www.youtube.com/user/LinusTechTips')
        .to_return(status: 200, body: '... channel_id=UCXuqSBlHAE6Xw-yeJA0Tunw ...', headers: {})
    end

    it { is_expected.to have_attributes(object: 'UCXuqSBlHAE6Xw-yeJA0Tunw') }
  end
end
