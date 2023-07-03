# frozen_string_literal: true

# == Schema Information
#
# Table name: cites
#
#  id           :bigint           not null, primary key
#  image_src    :string
#  intro        :text
#  link_url     :string
#  mention_date :datetime
#  prefix       :string
#  relevance    :integer
#  sentiment    :integer
#  suffix       :string
#  text_end     :string
#  text_start   :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  entity_id    :bigint           not null
#  mention_id   :bigint
#  user_id      :bigint           not null
#
# Indexes
#
#  index_cites_on_entity_id   (entity_id)
#  index_cites_on_mention_id  (mention_id)
#  index_cites_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_id => entities.id)
#  fk_rails_...  (mention_id => mentions.id)
#  fk_rails_...  (user_id => users.id)
#

class Cite < ApplicationRecord
  belongs_to :user
  belongs_to :entity
  belongs_to :mention, optional: true

  has_many :lookups_relations, as: :relation, dependent: :destroy
  has_many :lookups, -> { order(:id).distinct }, through: :lookups_relations

  has_many :images_relations, as: :relation, dependent: :destroy
  has_many :images, -> { includes(:images_relations).order('images_relations.order') }, through: :images_relations

  has_many :topics_relations, as: :relation, dependent: :destroy
  has_many :topics, -> { order(:id).distinct }, through: :topics_relations

  before_validation :strip_title
  before_validation :strip_intro

  validates :text_start, presence: true, if: -> { link_url.blank? }
  validates :link_url, presence: true, if: -> { text_start.blank? }

  include Elasticable
  index_name "#{Rails.env}.cites"

  def kinds_attributes=(attributes = {})
    attributes.each do |k, v|
    end
  end

  def as_indexed_json(_options = {})
    {
      id: id,
      entity_id: entity_id,
      title: title,
      intro: intro,
      text_start: text_start,
      text_end: text_end,
      prefix: prefix,
      suffix: suffix,
      link_url: link_url,
      relevance: relevance,
      sentiment: sentiment
    }
  end

  def strip_title
    self.title = title&.strip
  end

  def strip_intro
    self.intro = intro&.strip
  end

  # after_create_commit lambda {
  #   blocks = Entities::TimelineInteractor.call(entity_id: entity_id, count: 2).object
  #   content = ApplicationController.render(Entities::Timeline::BlockComponent.new(block: blocks.first))
  #   broadcast_prepend_to 'entities_timeline', target: 'entity_timeline_list', content: content
  # }
end
