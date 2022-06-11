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

class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  include ImageUploader::Attachment(:image)

  validates :image, presence: true
end
