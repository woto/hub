# frozen_string_literal: true

require 'rails_helper'

describe OfferCreator do
  subject do
    described_class.call(params)
  end

  describe 'detected_language' do
    let(:params) { { feed_category: create(:feed_category) } }

    it 'returns offer hash with russian detected_language by default' do
      expect(subject).to include('detected_language' => { 'code' => 'ru', 'name' => 'RUSSIAN' })
    end
  end
end
