# == Schema Information
#
# Table name: favorites_items
#
#  id          :bigint           not null, primary key
#  data        :jsonb
#  kind        :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ext_id      :string
#  favorite_id :bigint           not null
#
# Indexes
#
#  index_favorites_items_on_favorite_id  (favorite_id)
#
# Foreign Keys
#
#  fk_rails_...  (favorite_id => favorites.id)
#
FactoryBot.define do
  factory :favorites_item do
    favorite
    ext_id { Faker::Alphanumeric.alphanumeric }
    kind { FavoritesItem.kinds.keys.sample }
  end
end
