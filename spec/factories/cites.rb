# frozen_string_literal: true

# == Schema Information
#
# Table name: cites
#
#  id           :bigint           not null, primary key
#  image_src    :string
#  intro        :text
#  link_url     :string
#  mention_date :datetime
#  prefix       :string
#  relevance    :integer
#  sentiment    :integer
#  suffix       :string
#  text_end     :string
#  text_start   :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  entity_id    :bigint           not null
#  mention_id   :bigint
#  user_id      :bigint           not null
#
# Indexes
#
#  index_cites_on_entity_id   (entity_id)
#  index_cites_on_mention_id  (mention_id)
#  index_cites_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_id => entities.id)
#  fk_rails_...  (mention_id => mentions.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :cite do
    user
    title { Faker::Lorem.word }
    text_start { Faker::Lorem.word }
    entity
    mention
  end
end
