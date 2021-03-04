# frozen_string_literal: true

# == Schema Information
#
# Table name: feed_categories
#
#  id             :bigint           not null, primary key
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#  attempt_uuid   :uuid
#  name           :string
#  raw            :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ext_id         :string           not null
#  ext_parent_id  :string
#  feed_id        :bigint           not null
#
# Indexes
#
#  index_feed_categories_on_ancestry            (ancestry)
#  index_feed_categories_on_feed_id             (feed_id)
#  index_feed_categories_on_feed_id_and_ext_id  (feed_id,ext_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (feed_id => feeds.id)
#
class FeedCategory < ApplicationRecord
  include Elasticable
  index_name "#{Rails.env}.feed_categories"

  has_ancestry cache_depth: true
  belongs_to :feed

  validate :same_feed, if: -> { parent_id }

  def as_indexed_json(_options = {})
    categories_in_path = FeedCategory.unscoped.find(path_ids)
    path = path_ids[0...-1].map do |path_id|
      categories_in_path.find { |category| category.id == path_id }
    end

    {
      id: id,
      name: name,
      ancestry_depth: ancestry_depth,
      # TODO: Bugreport or fix it.
      # Next line doesn't work without overriding path above.
      # It makes wrong sql query with `WHERE ancestry = '...'` condition
      # feed_category, post_category
      path: path.map(&:name),
      leaf: children.none?,
      created_at: created_at.utc,
      updated_at: updated_at.utc,
      ext_id: ext_id,
      ext_parent_id: ext_parent_id,
      feed_id: feed_id
    }
  end

  def to_label
    name
  end

  def to_long_label
    "#{feed.to_long_label} -> #{path.map(&:name).join(' -> ')}"
  end

  private

  def same_feed
    errors.add(:base, 'Must belongs to same feed') if feed_id != parent.feed_id
  end
end
