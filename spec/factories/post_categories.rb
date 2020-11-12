# == Schema Information
#
# Table name: post_categories
#
#  id         :bigint           not null, primary key
#  ancestry   :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_post_categories_on_ancestry  (ancestry)
#
FactoryBot.define do
  factory :post_category do
    title { "MyString" }
  end
end
