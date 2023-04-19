# frozen_string_literal: true

require 'rails_helper'

describe OfferCreator do
  subject do
    described_class.call(**params)
  end

  describe 'detected_language' do
    let(:params) do
      { feed_category: create(:feed_category),
        name: 'Русское название товара',
        description: 'Русское описание товара' }
    end

    it 'returns offer hash with russian detected_language by default' do
      expect(subject).to include('detected_language' => { 'code' => 'ru', 'name' => 'RUSSIAN', 'reliable' => true })
    end
  end
end
