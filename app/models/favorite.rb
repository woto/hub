# frozen_string_literal: true

# == Schema Information
#
# Table name: favorites
#
#  id                    :bigint           not null, primary key
#  favorites_items       :integer          default(0), not null
#  favorites_items_count :integer
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
  # include Elasticsearch::Model::Callbacks
  index_name "#{Rails.env}.favorites"
  enum kind: { users: 0, posts: 1, transactions: 2, accounts: 3, checks: 4, news: 5, offers: 6, feeds: 7 }

  belongs_to :user

  has_many :favorites_items, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validates :kind, presence: true

  def as_indexed_json(_options = {})
    {
      id: id,
      favorites_items_count: favorites_items_count,
      kind: kind,
      name: name,
      created_at: created_at,
      updated_at: updated_at,
      user_id: user_id
    }
  end

  def to_label
    name
  end
end
