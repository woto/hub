class EntitiesTopic < ApplicationRecord
end

class MentionsTopic < ApplicationRecord
end

class MoveTopicsToTopicsRelations < ActiveRecord::Migration[6.1]
  def change
    EntitiesTopic.find_each do |et|
      TopicsRelation.create!(topic_id: et.topic_id, relation_id: et.entity_id, relation_type: 'Entity')
    end

    MentionsTopic.find_each do |mt|
      TopicsRelation.create!(topic_id: mt.topic_id, relation_id: mt.mention_id, relation_type: 'Mention')
    end
  end
end
