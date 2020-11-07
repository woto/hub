# == Schema Information
#
# Table name: offer_embeds
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  picture     :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_offer_embeds_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :offer_embed do
    user { nil }
    urls { "" }
  end
end
