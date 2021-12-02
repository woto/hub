# == Schema Information
#
# Table name: topics
#
#  id             :bigint           not null, primary key
#  mentions_count :integer          default(0), not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :topic do
    title { Faker::Lorem.unique.word }

    factory :topic_with_mentions do
      transient do
        mentions_count { 1 }
      end

      mentions do
        Array.new(mentions_count) do
          association(:mention, topics: [instance])
        end
      end
    end
  end
end
