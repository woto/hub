# == Schema Information
#
# Table name: topics_relations
#
#  id            :bigint           not null, primary key
#  relation_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  relation_id   :bigint           not null
#  topic_id      :bigint           not null
#  user_id       :bigint
#
# Indexes
#
#  index_topics_relations_on_relation  (relation_type,relation_id)
#  index_topics_relations_on_topic_id  (topic_id)
#  index_topics_relations_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :topics_relation do
    topic
    relation { nil }
    user
  end
end
