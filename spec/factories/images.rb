# == Schema Information
#
# Table name: images
#
#  id             :bigint           not null, primary key
#  image_data     :jsonb
#  imageable_type :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  imageable_id   :bigint           not null
#
# Indexes
#
#  index_images_on_imageable  (imageable_type,imageable_id)
#

FactoryBot.define do
  factory :image do
    imageable { nil }
    image_data { "" }
  end
end
