# == Schema Information
#
# Table name: entities_topics
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entity_id  :bigint           not null
#  topic_id   :bigint           not null
#
# Indexes
#
#  index_entities_topics_on_entity_id  (entity_id)
#  index_entities_topics_on_topic_id   (topic_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_id => entities.id)
#  fk_rails_...  (topic_id => topics.id)
#
FactoryBot.define do
  factory :entities_topic do
    entity { association(:entity) }
    topic { association(:topic) }
  end
end
