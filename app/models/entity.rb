# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id                :bigint           not null, primary key
#  image_data        :jsonb
#  intro             :text
#  lookups_count     :integer          default(0), not null
#  mentions_count    :integer          default(0), not null
#  metadata_iframely :jsonb
#  metadata_yandex   :jsonb
#  title             :string
#  topics_count      :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  hostname_id       :bigint
#  user_id           :bigint           not null
#
# Indexes
#
#  index_entities_on_hostname_id  (hostname_id)
#  index_entities_on_image_data   (image_data) USING gin
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

  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute
  include Topicable
  include Hostnameable
  hostnameable attribute_name: :title

  belongs_to :user, counter_cache: true

  has_rich_text :body

  has_many :entities_mentions, dependent: :restrict_with_error
  has_many :mentions, through: :entities_mentions, counter_cache: :mentions_count

  has_many :entities_topics, dependent: :destroy
  has_many :topics, through: :entities_topics

  has_many :children_entities, class_name: 'EntitiesEntity', foreign_key: 'parent_id', dependent: :destroy,
                               inverse_of: :parent
  has_many :children, class_name: 'Entity', through: :children_entities, source: :child, inverse_of: :parents

  has_many :parents_entities, class_name: 'EntitiesEntity', foreign_key: 'child_id', dependent: :destroy,
                              inverse_of: :child
  has_many :parents, class_name: 'Entity', through: :parents_entities, source: :parent, inverse_of: :children

  has_many :lookups, dependent: :destroy

  before_validation :strip_title
  before_validation :strip_intro

  validates :title, presence: true
  validates :intro, length: { maximum: 250 }

  accepts_nested_attributes_for :lookups, allow_destroy: true, reject_if: :all_blank

  def as_indexed_json(_options = {})
    {
      id: id,
      title: title,
      hostname: hostname.to_label,
      intro: intro,
      lookups: lookups.map(&:to_label),
      lookups_count: lookups_count,
      topics: topics.map(&:to_label),
      topics_count: topics_count,
      image: GlobalHelper.image_hash(self),
      user_id: user_id,
      created_at: created_at,
      updated_at: updated_at,
      mentions_count: mentions_count
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
