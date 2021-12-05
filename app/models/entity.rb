# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id             :bigint           not null, primary key
#  image_data     :jsonb
#  lookups_count  :integer          default(0), not null
#  mentions_count :integer          default(0), not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_entities_on_image_data  (image_data) USING gin
#  index_entities_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Entity < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.entities"

  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  belongs_to :user, counter_cache: true

  has_many :entities_mentions, dependent: :restrict_with_error
  has_many :mentions, through: :entities_mentions, counter_cache: :mentions_count

  has_many :lookups, dependent: :destroy

  validates :title, presence: true

  accepts_nested_attributes_for :lookups, allow_destroy: true, reject_if: :all_blank

  def as_indexed_json(_options = {})
    {
      id: id,
      title: title,
      lookups: lookups.map(&:to_label),
      lookups_count: lookups_count,
      image: image ? image.derivation_url(:thumbnail, 100, 100) : '',
      user_id: user_id,
      created_at: created_at,
      updated_at: updated_at,
      mentions_count: mentions_count
    }
  end

  def to_label
    title
  end
end
