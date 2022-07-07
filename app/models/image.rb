# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  image_data :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_images_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Image < ApplicationRecord
  belongs_to :user, optional: true
  include ImageUploader::Attachment(:image)

  validates :image, presence: true
end
