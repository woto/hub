# == Schema Information
#
# Table name: favorites
#
#  id                    :bigint           not null, primary key
#  favorites_items       :integer          default(0), not null
#  favorites_items_count :integer
#  is_default            :boolean          default(FALSE)
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
  belongs_to :user
  has_many :favorites_items, dependent: :destroy

  validates :name, presence: true

  validates :name, length: { maximum: 20 }

  enum kind: [:users, :offers, :feeds, :posts, :transactions, :accounts, :checks, :news, :post_categories]

  def as_indexed_json(_options = {})
    {
        id: id,
        favorites_items_count: favorites_items_count,
        is_default: is_default,
        kind: kind,
        name: name,
        created_at: created_at,
        updated_at: updated_at,
        user_id: user_id
    }
  end
end
