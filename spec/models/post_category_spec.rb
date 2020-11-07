# == Schema Information
#
# Table name: post_categories
#
#  id         :bigint           not null, primary key
#  ancestry   :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_post_categories_on_ancestry  (ancestry)
#
require 'rails_helper'

RSpec.describe PostCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
