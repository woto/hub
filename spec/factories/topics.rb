# == Schema Information
#
# Table name: topics
#
#  id                     :bigint           not null, primary key
#  title                  :string
#  topics_relations_count :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id                :bigint
#
# Indexes
#
#  index_topics_on_title    (title) UNIQUE
#  index_topics_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :topic do
    title { Faker::Lorem.unique.word }
    user
  end
end
