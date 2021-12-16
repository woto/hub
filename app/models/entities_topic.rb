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
class EntitiesTopic < ApplicationRecord
  belongs_to :entity, counter_cache: :topics_count
  belongs_to :topic, counter_cache: :entities_count
end
