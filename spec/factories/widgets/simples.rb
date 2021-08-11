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
    # widgets_simples_picture
    body { Faker::Lorem.paragraph(sentence_count: 10) }
  end
end

# TODO: could we replace it somehow only by using factory bot? Without defining method?
# By the way it is one of the recommended ways:
# https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#has_many-associations
# At least, it should be renamed.
def zzzzz
  FactoryBot.create(:widgets_simple, pictures: [FactoryBot.build(:widgets_simples_picture)])
end
