# frozen_string_literal: true

# == Schema Information
#
# Table name: favorites
#
#  id                    :bigint           not null, primary key
#  description           :text
#  favorites_items       :integer          default(0), not null
#  favorites_items_count :integer          default(0), not null
#  is_public             :boolean          default(FALSE)
#  kind                  :integer          not null
#  name                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :bigint           not null
#
# Indexes
#
#  index_favorites_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Favorite < ApplicationRecord
  include Elasticable
  index_name "#{Rails.env}.favorites"

  enum kind: { users: 0, posts: 1, transactions: 2, accounts: 3,
               checks: 4, feeds: 5, post_categories: 6, offers: 7, realms: 8, mentions: 9, entities: 10 }

  belongs_to :user, counter_cache: true

  has_many :favorites_items, dependent: :destroy

  validates :name, :kind, presence: true
  validates :name, length: { maximum: 30 }

  def as_indexed_json(_options = {})
    {
      id: id,
      favorites_items_count: favorites_items_count,
      kind: kind,
      name: name,
      created_at: created_at,
      updated_at: updated_at,
      user_id: user_id,
      is_public: is_public
    }
  end

  def to_label
    name
  end
end
