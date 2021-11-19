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
class Entity < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.entities"

  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  has_many :entities_mentions, dependent: :restrict_with_error
  has_many :mentions, through: :entities_mentions, counter_cache: :mentions_count

  validates :title, presence: true

  def as_indexed_json(_options = {})
    {
      id: id,
      title: title,
      aliases: aliases,
      image: image ? image.derivation_url(:thumbnail, 100, 100) : '',
      created_at: created_at,
      updated_at: updated_at,
      mentions_count: mentions_count
    }
  end

  def to_label
    title
  end
end
