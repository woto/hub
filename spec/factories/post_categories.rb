# == Schema Information
#
# Table name: post_categories
#
#  id             :bigint           not null, primary key
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#  posts_count    :integer          default(0)
#  priority       :integer          default(0), not null
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  realm_id       :bigint           not null
#
# Indexes
#
#  index_post_categories_on_ancestry  (ancestry)
#  index_post_categories_on_realm_id  (realm_id)
#
# Foreign Keys
#
#  fk_rails_...  (realm_id => realms.id)
#
FactoryBot.define do
  factory :post_category do
    title { Faker::Commerce.department(max: 2) }
    realm
  end
end
