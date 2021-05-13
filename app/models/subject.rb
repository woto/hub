# frozen_string_literal: true

# == Schema Information
#
# Table name: subjects
#
#  id         :bigint           not null, primary key
#  identifier :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subjects_on_identifier  (identifier) UNIQUE
#
class Subject < ApplicationRecord
  enum identifier: { 'hub': 0 }
  validates :identifier, presence: true, uniqueness: true

  has_many :accounts, as: :subjectable

  def to_label
    identifier
  end
end
