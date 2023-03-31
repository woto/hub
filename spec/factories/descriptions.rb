# == Schema Information
#
# Table name: descriptions
#
#  id            :bigint           not null, primary key
#  description   :text
#  title         :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  advertiser_id :integer          not null
#  feed_id       :integer          not null
#  offer_id      :string           not null
#
FactoryBot.define do
  factory :description do
    advertiser_id { 1 }
    feed_id { 1 }
    offer_id { "MyString" }
    title { "MyText" }
    description { "MyText" }
  end
end
