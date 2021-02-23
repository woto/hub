require 'rails_helper'

describe Feeds::Offers do
  describe 'Import::Offers::Language' do
    let(:feed) { create(:feed) }

    let(:doc) { Nokogiri::XML('<description>Отличный подарок для любителей венских вафель.</description>') }

    it 'calls Import::Offers::Language.call with correct argument' do
      expect(Import::Offers::Language).to receive(:call).with(
        include('description' => [include('#' => include('Отличный подарок для любителей венских вафель.'))]))
      instance = described_class.new(OpenStruct.new(feed: feed))
      instance.append(doc)
    end
  end
end
