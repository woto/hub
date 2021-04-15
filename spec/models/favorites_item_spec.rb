# frozen_string_literal: true

# == Schema Information
#
# Table name: favorites_items
#
#  id          :bigint           not null, primary key
#  kind        :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ext_id      :string
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
require 'rails_helper'

describe FavoritesItem, type: :model do
  # it_behaves_like 'elasticable'
  pending "add some examples to (or delete) #{__FILE__}"
end
