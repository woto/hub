# == Schema Information
#
# Table name: favorites_items
#
#  id          :bigint           not null, primary key
#  data        :jsonb
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

RSpec.describe FavoritesItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
