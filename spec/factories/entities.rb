# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id             :bigint           not null, primary key
#  image_data     :jsonb
#  intro          :text
#  lookups_count  :integer          default(0), not null
#  mentions_count :integer          default(0), not null
#  title          :string
#  topics_count   :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_entities_on_image_data  (image_data) USING gin
#  index_entities_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :entity do
    user
    title { Faker::Lorem.word }
  end
end
