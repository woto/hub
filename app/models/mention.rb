# frozen_string_literal: true

# == Schema Information
#
# Table name: mentions
#
#  id             :bigint           not null, primary key
#  entities_count :integer          default(0), not null
#  image_data     :jsonb
#  kind           :integer          not null
#  published_at   :datetime
#  sentiment      :integer          not null
#  tags           :jsonb
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
class Mention < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.mentions"

  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  enum kind: { text: 0, image: 1, audio: 2, video: 3 }
  enum sentiment: { positive: 0, negative: 1, unknown: 2 }

  belongs_to :user, counter_cache: true

  has_many :entities_mentions
  has_many :entities, through: :entities_mentions, counter_cache: :entities_count

  validates :entities, :url, :tags, :sentiment, :kind, presence: true
  validates :tags, length: { minimum: 2 }
  validates :entities, length: { minimum: 1 }
  validates :url, uniqueness: true
  validates :image, presence: true

  before_destroy :stop_destroy

  def as_indexed_json(_options = {})
    {
      id: id,
      kind: kind,
      published_at: published_at,
      sentiment: sentiment,
      tags: tags,
      url: url,
      created_at: created_at,
      updated_at: updated_at,
      user_id: user_id,
      image: image.derivation_url(:thumbnail, 100, 100),
      entity_ids: entity_ids,
      entities: entities.map(&:title),
      entities_count: entities_count
    }
  end

  private

  def stop_destroy
    errors.add(:base, :undestroyable)
    throw :abort
  end
end
