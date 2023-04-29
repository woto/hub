# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id                      :bigint           not null, primary key
#  entities_mentions_count :integer          default(0), not null
#  image_src               :string
#  intro                   :text
#  lookups_count           :integer          default(0), not null
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  hostname_id             :bigint
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_entities_on_hostname_id  (hostname_id)
#  index_entities_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (hostname_id => hostnames.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :entity do
    user
    title { Faker::Lorem.word }
    intro { Faker::Lorem.sentence }

    transient do
      index { true }
    end

    trait(:with_image) do
      images { [association(:image)] }
    end

    after(:create) do |entity, evaluator|
      entity.__elasticsearch__.index_document if evaluator.index
    end
  end
end
