# frozen_string_literal: true

require 'rails_helper'

describe OfferDecorator do
  describe '#pictures' do
    def proxied_url(url)
      format(ENV.fetch('IMGPROXY_URL'), url)
    end

    subject { described_class.new(offer).pictures }

    context 'when `picture` is filled' do
      let(:offer) { { '_source' => { 'picture' => [Import::Offers::Hashify::HASH_BANG_KEY => picture] } } }
      let(:picture) { Faker::Internet.url }

      it { is_expected.to contain_exactly(proxied_url(picture)) }
    end

    context 'when `picture` is empty' do
      let(:offer) { { '_source' => { 'picture' => [] } } }

      it { is_expected.to contain_exactly(proxied_url('local:///image-not-found.png')) }
    end
  end

  describe '#name' do
    subject { described_class.new(offer).name }

    let(:offer) { { '_source' => { 'name' => [Import::Offers::Hashify::HASH_BANG_KEY => name] } } }
    let(:name) { Faker::Commerce.product_name }

    it { is_expected.to eq(name) }
  end
end
