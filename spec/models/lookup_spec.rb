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
require 'rails_helper'

RSpec.describe Lookup, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:lookups_relations) }
    it { is_expected.to have_many(:entities).through(:lookups_relations).source(:relation) }
    it { is_expected.to have_many(:mentions).through(:lookups_relations).source(:relation) }
    it { is_expected.to have_many(:cites).through(:lookups_relations).source(:relation) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe '#to_label' do
    subject { create(:entity, title: 'title') }

    specify do
      expect(subject.to_label).to eq('title')
    end
  end

  describe '#strip_title' do
    subject { build(:lookup, title: " hello \n ") }

    it 'strips title' do
      subject.save!
      expect(subject.reload.title).to eq('hello')
    end
  end
end
