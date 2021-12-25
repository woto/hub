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
#  sentiments     :jsonb
#  title          :string
#  topics_count   :integer          default(0), not null
#  url            :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  hostname_id    :bigint
#  user_id        :bigint           not null
#
# Indexes
#
#  index_mentions_on_hostname_id  (hostname_id)
#  index_mentions_on_image_data   (image_data) USING gin
#  index_mentions_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (hostname_id => hostnames.id)
#  fk_rails_...  (user_id => users.id)
#
class Mention < ApplicationRecord
  KINDS = %w[text image video audio].freeze
  SENTIMENTS = %w[positive negative].freeze

  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.mentions"

  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute
  include ImageHash
  include Topicable
  include Hostnameable
  hostnameable attribute_name: :url

  belongs_to :user, counter_cache: true

  has_many :entities_mentions, dependent: :destroy, autosave: true
  has_many :entities, through: :entities_mentions, counter_cache: :entities_count

  has_many :mentions_topics, dependent: :destroy
  has_many :topics, through: :mentions_topics, counter_cache: :topics_count

  before_validation :strip_title
  before_validation :strip_url

  validates :entities_mentions, :url, presence: true
  validates :url, uniqueness: true
  validate :validate_kinds_keys
  validate :validate_sentiments_keys

  # before_destroy :stop_destroy

  # NOTE: it's used for mention form this life hack raised
  # due to the problem described here https://github.com/rails/rails/issues/43775
  def related_entities=(hsh)
    items = hsh.values
    items = items.uniq { |obj| obj['id'] }
    entities_mentions = []
    items.each do |value|
      entities_mention = EntitiesMention.find_or_initialize_by(mention_id: self.id.to_i, entity_id: value['id'].to_i)
      entities_mention.is_main = ActiveModel::Type::Boolean.new.cast(value['is_main'])
      entities_mentions << entities_mention
    end
    self.entities_mentions = entities_mentions
  end

  def to_param
    [id, title&.parameterize].join('-')
  end

  def as_indexed_json(_options = {})
    {
      id: id,
      kinds: kinds,
      published_at: published_at,
      sentiments: sentiments,
      topics: topics.map(&:to_label),
      topics_count: topics_count,
      hostname: hostname.to_label,
      url: url,
      title: title,
      created_at: created_at,
      updated_at: updated_at,
      user_id: user_id,
      image: image_hash,
      entity_ids: entity_ids,
      # TODO: Rails 7 in order of
      entities: entities_hash,
      entities_count: entities_count
    }
  end

  def entities_hash
    entities_mentions.includes(:entity).order(is_main: :desc).map do |entity_mention|
      {
        'id' => entity_mention.entity_id,
        'title' => entity_mention.entity.to_label,
        'is_main' => entity_mention.is_main
      }
    end
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

  # TODO: find gem to avoid manual validation
  def validate_sentiments_keys
    return if errors.include?(:sentiments)

    errors.add(:sentiments, :inclusion) unless (sentiments - ['', *SENTIMENTS]).empty?
  end

  def strip_title
    self.title = title&.strip
  end

  def strip_url
    self.url = url&.strip
  end
end
