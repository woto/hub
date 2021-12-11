# frozen_string_literal: true

# == Schema Information
#
# Table name: mentions
#
#  id             :bigint           not null, primary key
#  entities_count :integer          default(0), not null
#  html           :text
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

  before_validation :strip_title
  before_validation :strip_url

  validates :topics, :image, :entities, :url, :sentiment, :kinds, presence: true
  validates :entities, :topics, length: { minimum: 1 }
  validates :url, uniqueness: true
  validate :validate_kinds_keys, :validate_kinds_length

  # before_destroy :stop_destroy

  # NOTE: it's used for mention form this life hack raised
  # due to the problem described here https://github.com/rails/rails/issues/43775
  def entity_form_ids=(ids)
    entities = Entity.find(ids.compact_blank)
    self.entities = entities
  end

  def topics_attributes=(titles)
    topics = []

    titles.each do |title|
      # TODO: write article
      # If remove this line then you could not pass topic with empty title.
      # The exception ActiveRecord::RecordInvalid will be raised
      next if title.blank?

      topics << Topic.find_or_create_by(title: title)
    end

    self.topics = topics
  end

  def to_param
    [id, title&.parameterize].join('-')
  end

  def as_indexed_json(_options = {})
    {
      id: id,
      kinds: kinds,
      published_at: published_at,
      sentiment: sentiment,
      topics: topics.map(&:to_label),
      url: url,
      title: title,
      created_at: created_at,
      updated_at: updated_at,
      user_id: user_id,
      # TODO: could we just send image_data?
      image: {
        image_original: image_url,
        image_thumbnail: image.derivation_url(:thumbnail, 300, 300),
        width: image.metadata['width'],
        height: image.metadata['height']
      },
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
  def validate_kinds_keys
    return if errors.include?(:kinds)

    errors.add(:kinds, :inclusion) unless (kinds - ['', *KINDS]).empty?
  end

  def validate_kinds_length
    errors.add(:kinds, :inclusion) if Array(kinds).compact_blank.empty?
  end

  def strip_title
    self.title = title&.strip
  end

  def strip_url
    self.url = url&.strip
  end
end
