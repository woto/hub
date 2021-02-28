# frozen_string_literal: true

# == Schema Information
#
# Table name: post_categories
#
#  id         :bigint           not null, primary key
#  ancestry   :string
#  priority   :integer          default(0), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  realm_id   :bigint           not null
#
# Indexes
#
#  index_post_categories_on_ancestry  (ancestry)
#  index_post_categories_on_realm_id  (realm_id)
#
# Foreign Keys
#
#  fk_rails_...  (realm_id => realms.id)
#
require 'rails_helper'

describe PostCategory, type: :model do
  it_behaves_like 'elasticable'
  pending "add some examples to (or delete) #{__FILE__}"
end
