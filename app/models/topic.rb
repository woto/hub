# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                     :bigint           not null, primary key
#  title                  :string
#  topics_relations_count :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id                :bigint
#
# Indexes
#
#  index_topics_on_title    (title) UNIQUE
#  index_topics_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Topic < ApplicationRecord
  include Elasticable
  index_name "#{Rails.env}.topics"

  belongs_to :user, optional: true

  has_many :topics_relations, dependent: :destroy
  has_many :entities, through: :topics_relations, source: :relation, source_type: 'Entity'
  has_many :mentions, through: :topics_relations, source: :relation, source_type: 'Mention'
  has_many :cites, through: :topics_relations, source: :relation, source_type: 'Cite'

  validates :title, presence: true
  validates :title, uniqueness: true
  validates :title, length: { maximum: 50 }

  def to_label
    title
  end

  def as_indexed_json(_options = {})
    {
      id: id,
      title: title,
      topics_relations_count: topics_relations_count,
      created_at: created_at.utc,
      updated_at: updated_at.utc
    }
  end
end
