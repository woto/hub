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
FactoryBot.define do
  factory :subject do
    identifier { Subject.identifiers.keys.sample }
  end
end
