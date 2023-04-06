# frozen_string_literal: true

# == Schema Information
#
# Table name: mentions
#
#  id            :bigint           not null, primary key
#  canonical_url :text
#  html          :text
#  kinds         :jsonb            not null
#  published_at  :datetime
#  sentiments    :jsonb
#  title         :string
#  url           :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  hostname_id   :bigint
#  user_id       :bigint           not null
#
# Indexes
#
#  index_mentions_on_hostname_id  (hostname_id)
#  index_mentions_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (hostname_id => hostnames.id)
#  fk_rails_...  (user_id => users.id)
#
class Mention < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticsearch::Model
  index_name "#{Rails.env}.mentions"

  include Topicable
  include Hostnameable
  hostnameable attribute_name: :url

  belongs_to :user

  has_many :cites, dependent: :destroy

  has_many :entities_mentions, dependent: :destroy
  has_many :entities, -> { distinct }, through: :entities_mentions

  has_many :topics_relations, as: :relation, dependent: :destroy
  has_many :topics, -> { distinct }, through: :topics_relations

  has_many :images_relations, as: :relation, dependent: :destroy
  has_many :images, -> { distinct }, through: :images_relations

  before_validation :strip_title
  before_validation :strip_url

  validates :url, presence: true
  validates :url, uniqueness: true

  # before_destroy :stop_destroy

  # # NOTE: it's used for mention form this life hack raised
  # # due to the problem described here https://github.com/rails/rails/issues/43775
  # def related_entities=(hsh)
  #   items = hsh.values
  #   items = items.uniq { |obj| obj['id'] }
  #   entities_mentions = []
  #   items.each do |value|
  #     entities_mention = EntitiesMention.find_or_initialize_by(mention_id: id.to_i, entity_id: value['id'].to_i)
  #     entities_mention.is_main = ActiveModel::Type::Boolean.new.cast(value['is_main'])
  #     entities_mentions << entities_mention
  #   end
  #   self.entities_mentions = entities_mentions
  # end

  def to_param
    [id, title&.parameterize].join('-')
  end

  settings index: { number_of_shards: 1, number_of_replicas: 0 } do
    mapping do
      indexes :id, type: 'long'
      indexes :entities, type: 'nested' do
        indexes :id, type: 'long'
        indexes :entity_id, type: 'long'
        indexes :created_at, type: 'date'
        indexes :mention_date, type: 'date'
        indexes :relevance, type: 'long'
        indexes :sentiment, type: 'float'
      end
      indexes :title, type: 'text' do
        indexes :autocomplete, type: 'search_as_you_type'
        indexes :keyword, type: 'keyword'
      end
      indexes :slug, type: 'keyword'
      indexes :hostname, type: 'text'
      indexes :topics do
        indexes :id, type: 'long'
        indexes :title, type: 'text'
      end
      indexes :url, type: 'text'
      indexes :user_id, type: 'long'
      indexes :created_at, type: 'date'
      indexes :updated_at, type: 'date'
      indexes :published_at, type: 'date'
    end
  end

  def as_indexed_json(_options = {})
    image_relation = images_relations.slice(-1, 1)
    {
      id: id,
      published_at: published_at,
      topics: topics.map { |topic| { id: topic.id, title: topic.title } },
      hostname: hostname.to_label,
      url: url,
      title: title,
      slug: to_param,
      created_at: created_at,
      updated_at: updated_at,
      user_id: user_id,
      image: (GlobalHelper.image_hash(image_relation, %w[50 100 200 300 500 1000]) if image_relation),
      # entity_ids: entity_ids,
      # TODO: Rails 7 in order of
      entities: entities_hash,
    }
  end

  def entities_hash
    # entities_mentions.includes(:entity).order(is_main: :desc).map do |entity_mention|
    entities_mentions
      .order(relevance: :asc, mention_date: :desc, sentiment: :asc)
      .map do |entity_mention|
      {
        'id' => entity_mention.id,
        'entity_id' => entity_mention.entity_id,
        'mention_id' => entity_mention.mention_id,
        'relevance' => entity_mention.relevance,
        'sentiment' => entity_mention.sentiment,
        'mention_date' => entity_mention.mention_date,
        'created_at' => entity_mention.created_at
      }
    end
  end

  private

  # def stop_destroy
  #   errors.add(:base, :undestroyable)
  #   throw :abort
  # end

  def strip_title
    self.title = title&.strip
  end

  def strip_url
    self.url = url&.strip
  end
end
