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
include ActionDispatch::TestProcess

FactoryBot.define do
  factory :widgets_simple, class: 'Widgets::Simple' do
    title { Faker::Commerce.product_name }
    url do
      url = Faker::Internet.url
      OfferCreator.call(url: url, feed_category: create(:feed_category))
      url
    end
    # see comments in spec/requests/settings/avatars_controller_spec.rb
    pictures do
      [
        Rack::Test::UploadedFile.new('spec/fixtures/files/adriana_chechik.jpg'),
        Rack::Test::UploadedFile.new('spec/fixtures/files/jessa_rhodes.jpg')
      ]
    end
    body { Faker::Lorem.paragraph(sentence_count: 10) }
  end
end
