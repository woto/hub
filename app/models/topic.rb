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
class Topic < ApplicationRecord
  has_many :mentions_topics, dependent: :destroy
  has_many :mentions, through: :mentions_topics, counter_cache: :mentions_count

  validates :title, presence: true

  def to_label
    title
  end
end
