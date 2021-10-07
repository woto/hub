# frozen_string_literal: true

# == Schema Information
#
# Table name: favorites_items
#
#  id          :bigint           not null, primary key
#  kind        :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ext_id      :string           not null
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

  enum kind: { users: 0, posts: 1, transactions: 2, accounts: 3, checks: 4, feeds: 5, post_categories: 6,
               advertiser_id: 7, feed_id: 8, feed_category_id: 9, _id: 10, realms: 11 }

  validates :ext_id, :kind, presence: true
  validate :kind, :check_kind_matching

  def self.favorites_item_kind_to_favorite_kind(kind)
    case kind.to_s
    when 'advertiser_id', 'feed_id', 'feed_category_id', '_id'
      'offers'
    else
      kind
    end
  end

  private

  def check_kind_matching
    return unless kind
    return unless favorite

    errors.add(:kind, :invalid) if self.class.favorites_item_kind_to_favorite_kind(kind) != favorite.kind
  end
end
