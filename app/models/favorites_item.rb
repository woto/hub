# frozen_string_literal: true

# == Schema Information
#
# Table name: favorites_items
#
#  id          :bigint           not null, primary key
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
class FavoritesItem < ApplicationRecord
  belongs_to :favorite, counter_cache: true

  enum kind: { users: 0, posts: 1, transactions: 2, accounts: 3, checks: 4, news: 5, feeds: 6,
               advertiser_id: 7, feed_id: 8, feed_category_id: 9, _id: 10 }

  validates :kind, presence: true
end
