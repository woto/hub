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
require 'rails_helper'

RSpec.describe Topic, type: :model do
  it_behaves_like 'elasticable'

  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:topics_relations).dependent(:destroy) }
    it { is_expected.to have_many(:mentions).through(:topics_relations).source(:relation) }
    it { is_expected.to have_many(:entities).through(:topics_relations).source(:relation) }
    it { is_expected.to have_many(:cites).through(:topics_relations).source(:relation) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(50) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe '#to_label' do
    subject { create(:topic, title: 'title') }

    specify do
      expect(subject.to_label).to eq('title')
    end
  end

  describe 'factory' do
    subject(:topic) { create(:topic, user: user) }

    let(:user) { create(:user) }
    let(:relation1) { create(:mention) }
    let(:relation2) { create(:mention) }

    before do
      create(:topics_relation, user: user, topic: topic, relation: relation1)
      create(:topics_relation, user: user, topic: topic, relation: relation2)
    end

    specify do
      expect(topic.mentions.count).to eq(2)
    end
  end

  context 'when removes topic with mention' do
    subject(:topic) { create(:topic, user: user) }

    let(:user) { create(:user) }
    let(:relation) { create(:mention) }

    before do
      create(:topics_relation, user: user, topic: topic, relation: relation)
    end

    it 'removes topics_relation' do
      expect { topic.destroy! }.not_to change(Mention, :count)
    end

    it 'does not remove mention' do
      expect { topic.destroy! }.to change(TopicsRelation, :count).from(1).to(0)
    end
  end
end
