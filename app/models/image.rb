# == Schema Information
#
# Table name: images
#
#  id          :bigint           not null, primary key
#  image_data  :jsonb
#  youtube_url :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
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

  has_many :images_relations, dependent: :destroy
  has_many :entities, through: :images_relations, source: :relation, source_type: 'Entity'
  has_many :mentions, through: :images_relations, source: :relation, source_type: 'Mention'
  has_many :cites, through: :images_relations, source: :relation, source_type: 'Cite'
end
