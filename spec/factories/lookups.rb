# == Schema Information
#
# Table name: lookups
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entity_id  :bigint           not null
#
# Indexes
#
#  index_lookups_on_entity_id  (entity_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_id => entities.id)
#
FactoryBot.define do
  factory :lookup do
    entity
    title { Faker::Lorem.word }
  end
end
