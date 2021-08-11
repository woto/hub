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
    body { Faker::Lorem.paragraph(sentence_count: 10) }
    # TODO: don't know why this doesn't work
    # pictures { [association(:widgets_simples_picture)] }

    after(:build) do |widgets_simple, evaluator|
      widgets_simple.pictures = [FactoryBot.build(:widgets_simples_picture)]
    end
  end
end
