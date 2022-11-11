# == Schema Information
#
# Table name: favorites
#
#  id                    :bigint           not null, primary key
#  description           :text
#  favorites_items       :integer          default(0), not null
#  favorites_items_count :integer          default(0), not null
#  is_public             :boolean          default(FALSE)
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
FactoryBot.define do
  factory :favorite do
    user
    name { Faker::Lorem.word }
    kind { Favorite.kinds.keys.sample }
  end
end
