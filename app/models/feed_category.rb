# == Schema Information
#
# Table name: feed_categories
#
#  id                :bigint           not null, primary key
#  ancestry          :string
#  data              :jsonb
#  last_attempt_uuid :uuid             not null
#  name              :string
#  parent_not_found  :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  ext_id            :string           not null
#  ext_parent_id     :string
#  feed_id           :bigint           not null
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
  has_ancestry
  belongs_to :feed
end
