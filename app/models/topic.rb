# == Schema Information
#
# Table name: topics
#
#  id             :bigint           not null, primary key
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

  validates :title, presence: true
  validates :title, uniqueness: true

  def to_label
    title
  end
end
