# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id             :bigint           not null, primary key
#  entities_count :integer          default(0), not null
#  mentions_count :integer          default(0), not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_topics_on_title  (title) UNIQUE
#
class Topic < ApplicationRecord
  include Elasticable
  index_name "#{Rails.env}.topics"

  has_many :mentions_topics, dependent: :destroy
  has_many :mentions, through: :mentions_topics, counter_cache: :mentions_count

  has_many :entities_topics, dependent: :destroy
  has_many :entities, through: :entities_topics, counter_cache: :entities_count

  validates :title, presence: true
  validates :title, uniqueness: true
  validates :title, length: { maximum: 50 }

  def to_label
    title
  end
end
