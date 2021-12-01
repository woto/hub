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
class Mention < ApplicationRecord
  KINDS = %w[text image video audio].freeze

  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.mentions"

  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  enum sentiment: { positive: 0, negative: 1, unknown: 2 }

  belongs_to :user, counter_cache: true

  has_many :entities_mentions, dependent: :destroy
  has_many :entities, through: :entities_mentions, counter_cache: :entities_count

  has_many :mentions_topics, dependent: :destroy
  has_many :topics, through: :mentions_topics, counter_cache: :topics_count

  validates :topics, :image, :entities, :url, :sentiment, :kinds, presence: true
  validates :entities, :topics, length: { minimum: 1 }
  validates :url, uniqueness: true
  validate :validate_kinds

  # before_destroy :stop_destroy

  accepts_nested_attributes_for :topics, allow_destroy: true

  # def topics_attributes=(val)
  #   TODO: old or new topics
  # end

  def as_indexed_json(_options = {})
    {
      id: id,
      kinds: kinds,
      published_at: published_at,
      sentiment: sentiment,
      topics: topics.map(&:to_label),
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

  # def stop_destroy
  #   errors.add(:base, :undestroyable)
  #   throw :abort
  # end

  # TODO: find gem to avoid manual validation
  def validate_kinds
    return if errors.include?(:kinds)

    errors.add(:kinds, :inclusion) unless (kinds - ['', *KINDS]).empty?
  end
end
