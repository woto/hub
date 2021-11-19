# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id             :bigint           not null, primary key
#  aliases        :jsonb
#  image_data     :jsonb
#  mentions_count :integer          default(0), not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_entities_on_image_data  (image_data) USING gin
#

FactoryBot.define do
  factory :entity do
    title { Faker::Lorem.word }
    # aliases { 5.times.map { Faker::Lorem.word } }
  end
end
