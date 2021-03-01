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
require 'rails_helper'

describe FeedCategory, type: :model do
  it_behaves_like 'elasticable'
  pending "add some examples to (or delete) #{__FILE__}"
end
