# frozen_string_literal: true

# == Schema Information
#
# Table name: lookups
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_lookups_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Lookup < ApplicationRecord
  belongs_to :user, optional: true

  before_validation :strip_title

  validates :title, presence: true

  has_many :lookups_relations, dependent: :destroy
  has_many :entities, through: :lookups_relations, source: :relation, source_type: 'Entity'
  has_many :mentions, through: :lookups_relations, source: :relation, source_type: 'Mention'
  has_many :cites, through: :lookups_relations, source: :relation, source_type: 'Cite'

  def to_label
    title
  end

  private

  def strip_title
    self.title = title&.strip
  end
end
