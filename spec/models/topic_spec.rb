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
require 'rails_helper'

RSpec.describe Topic, type: :model do
  it_behaves_like 'elasticable'

  describe 'associations' do
    it { is_expected.to have_many(:mentions_topics).dependent(:destroy) }
    it { is_expected.to have_many(:mentions).through(:mentions_topics).counter_cache(:mentions_count) }

    it { is_expected.to have_many(:entities_topics).dependent(:destroy) }
    it { is_expected.to have_many(:entities).through(:entities_topics).counter_cache(:entities_count) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(50) }
  end

  describe '#to_label' do
    subject { create(:topic, title: 'title') }

    specify do
      expect(subject.to_label).to eq('title')
    end
  end

  describe 'factory' do
    subject! { create(:topic_with_mentions, mentions_count: 2) }

    specify do
      expect(subject.mentions.count).to eq(2)
    end
  end

  context 'when removes topic with mention' do
    subject! { create(:topic_with_mentions) }

    it 'does not remove mention' do
      expect do
        expect do
          subject.destroy!
        end.to change(described_class, :count).from(1).to(0)
      end.not_to change(Mention, :count).from(1)
    end
  end
end
