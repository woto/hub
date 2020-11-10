# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  extra_options    :jsonb
#  language         :string
#  price            :integer          default(0), not null
#  status           :integer          not null
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  post_category_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_posts_on_post_category_id  (post_category_id)
#  index_posts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_category_id => post_categories.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
