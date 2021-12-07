# frozen_string_literal: true

# == Schema Information
#
# Table name: mentions
#
#  id             :bigint           not null, primary key
#  entities_count :integer          default(0), not null
#  image_data     :jsonb
#  kinds          :jsonb            not null
#  published_at   :datetime
#  sentiment      :integer          not null
#  title          :string
#  topics_count   :integer          default(0), not null
#  url            :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_mentions_on_image_data  (image_data) USING gin
#  index_mentions_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require_relative '../support/shrine_image'

FactoryBot.define do
  factory :mention do
    user
    entities { [association(:entity)] }
    url { Faker::Internet.url }
    topics { [association(:topic)] }
    sentiment { Mention.sentiments.keys.sample }
    kinds { Mention::KINDS.sample(rand(Mention::KINDS.size) + 1) }
    image_data { ShrineImage.image_data }
  end
end
