# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id                      :bigint           not null, primary key
#  entities_mentions_count :integer          default(0), not null
#  image_src               :string
#  intro                   :text
#  lookups_count           :integer          default(0), not null
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  hostname_id             :bigint
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_entities_on_hostname_id  (hostname_id)
#  index_entities_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (hostname_id => hostnames.id)
#  fk_rails_...  (user_id => users.id)
#
class Entity < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.entities"

  include Topicable
  include Hostnameable
  hostnameable attribute_name: :title

  belongs_to :user

  has_rich_text :body

  has_many :cites, dependent: :destroy

  has_many :entities_mentions, dependent: :destroy
  has_many :mentions, through: :entities_mentions

  has_many :children_entities, class_name: 'EntitiesEntity', foreign_key: 'parent_id', dependent: :destroy,
                               inverse_of: :parent
  has_many :children, class_name: 'Entity', through: :children_entities, source: :child, inverse_of: :parents

  has_many :parents_entities, class_name: 'EntitiesEntity', foreign_key: 'child_id', dependent: :destroy,
                              inverse_of: :child
  has_many :parents, class_name: 'Entity', through: :parents_entities, source: :parent, inverse_of: :children

  has_many :lookups_relations, as: :relation, dependent: :destroy
  has_many :lookups, -> { order(:id).distinct }, through: :lookups_relations

  has_many :topics_relations, as: :relation, dependent: :destroy
  has_many :topics, -> { order(:id).distinct }, through: :topics_relations

  has_many :images_relations, -> { order('images_relations.order') }, as: :relation, dependent: :destroy, inverse_of: :relation
  has_many :images, through: :images_relations

  before_validation :strip_title
  before_validation :strip_intro

  validates :title, :intro, presence: true
  validates :intro, length: { maximum: 500 }

  accepts_nested_attributes_for :lookups, allow_destroy: true, reject_if: :all_blank

  settings index: { number_of_shards: 1, number_of_replicas: 0 } do
    mapping do
      indexes :entities_mentions_count, type: 'long'
      indexes :hostname, type: 'text'
      indexes :id, type: 'long'
      indexes :intro, type: 'text'
      indexes :link_url, type: 'text' do
        indexes :keyword, type: 'keyword'
      end
      indexes :lookups do
        indexes :id, type: 'long'
        indexes :title, type: 'text'
      end
      indexes :prefix, type: 'text'
      indexes :suffix, type: 'text'
      indexes :text_start, type: 'text'
      indexes :text_end, type: 'text'
      indexes :title, type: 'text' do
        indexes :autocomplete, type: 'search_as_you_type'
        indexes :keyword, type: 'keyword'
      end
      indexes :topics do
        indexes :id, type: 'long'
        indexes :title, type: 'text'
      end
      indexes :user_id, type: 'long'
      indexes :created_at, type: 'date'
      indexes :updated_at, type: 'date'
    end
  end

  def as_indexed_json(_options = {})
    {
      id:,
      title:,
      text_start: cites.map(&:text_start),
      text_end: cites.map(&:text_end),
      prefix: cites.map(&:prefix),
      suffix: cites.map(&:suffix),
      link_url: cites.map(&:link_url).compact,
      hostname: hostname&.to_label,
      intro:,
      lookups: lookups.map { |lookup| { id: lookup.id, title: lookup.title } },
      topics: topics.map { |topic| { id: topic.id, title: topic.title } },
      images: GlobalHelper.image_hash(images_relations, %w[50 100 200 300 500 1000]),
      user_id:,
      created_at:,
      updated_at:,
      entities_mentions_count:
    }
  end

  def to_label
    title
  end

  def to_param
    [id, title&.parameterize].join('-')
  end

  private

  def strip_title
    self.title = title&.strip
  end

  def strip_intro
    self.intro = intro&.strip
  end
end
