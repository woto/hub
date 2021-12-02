# == Schema Information
#
# Table name: mentions_topics
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mention_id :bigint           not null
#  topic_id   :bigint           not null
#
# Indexes
#
#  index_mentions_topics_on_mention_id  (mention_id)
#  index_mentions_topics_on_topic_id    (topic_id)
#
# Foreign Keys
#
#  fk_rails_...  (mention_id => mentions.id)
#  fk_rails_...  (topic_id => topics.id)
#
FactoryBot.define do
  factory :mentions_topic do
    mention
    topic
  end
end
