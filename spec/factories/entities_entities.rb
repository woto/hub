# == Schema Information
#
# Table name: entities_entities
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  child_id   :bigint           not null
#  parent_id  :bigint           not null
#
# Indexes
#
#  index_entities_entities_on_child_id   (child_id)
#  index_entities_entities_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (child_id => entities.id)
#  fk_rails_...  (parent_id => entities.id)
#
FactoryBot.define do
  factory :entities_entity do
    parent { association(:entity) }
    child { association(:entity) }
  end
end
