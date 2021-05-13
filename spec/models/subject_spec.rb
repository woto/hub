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
require 'rails_helper'

describe Subject, type: :model do
  it { is_expected.to define_enum_for(:identifier).with_values([:hub]) }
  it { is_expected.to validate_presence_of(:identifier) }
  it { is_expected.to have_db_index(:identifier).unique }
  it { is_expected.to have_many(:accounts) }

  describe 'uniqueness of identifier' do
    subject { create(:subject) }

    it { is_expected.to validate_uniqueness_of(:identifier).ignoring_case_sensitivity }
  end

  describe '#to_label' do
    subject { subject_object.to_label }

    let(:subject_object) { create(:subject) }

    it { is_expected.to eq(subject_object.identifier) }
  end
end
