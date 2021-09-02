# frozen_string_literal: true

# == Schema Information
#
# Table name: widgets_simples
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Widgets::Simple, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to have_many(:pictures) }
  it { is_expected.to have_one(:widget).touch(true) }

  describe '#url_valid?' do
    subject do
      described_class.new(url: url, title: 'title', body: 'body',
                          pictures: [Widgets::Simples::Picture.new(
                            picture: Rack::Test::UploadedFile.new(file_fixture('adriana_chechik.jpg'))
                          )])
    end

    let!(:offer) { OfferCreator.call(feed_category: create(:feed_category)) }

    context 'with url of existing offer' do
      let(:url) { offer['url'][0][Import::Offers::Hashify::HASH_BANG_KEY] }

      it 'does not have error on url field' do
        expect(subject).to be_valid
        expect(subject.errors.details).not_to include(:url)
      end
    end

    context 'with url of not existing offer' do
      let(:url) { Faker::Internet.url }

      it 'has error on url field' do
        expect(subject).to be_invalid
        expect(subject.errors.details).to eq(url: [{ error: :invalid }])
      end
    end
  end
end
