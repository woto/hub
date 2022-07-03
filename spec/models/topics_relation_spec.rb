# == Schema Information
#
# Table name: topics_relations
#
#  id            :bigint           not null, primary key
#  relation_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  relation_id   :bigint           not null
#  topic_id      :bigint           not null
#  user_id       :bigint
#
# Indexes
#
#  index_topics_relations_on_relation  (relation_type,relation_id)
#  index_topics_relations_on_topic_id  (topic_id)
#  index_topics_relations_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe TopicsRelation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to belong_to(:topic).counter_cache }
    # NOTE: don't know if there is and feature which checks polymorphic association
    it { is_expected.to belong_to(:relation) }
  end

  describe 'validations' do
    let(:entity) { create(:entity) }
    let(:topic) { create(:topic) }

    def create_topics_relation
      TopicsRelation.create(topic: topic, relation: entity)
    end

    # NOTE: Bug. Doesn't work like this
    # it { is_expected.to validate_uniqueness_of(:topic).scoped_to(:relation) }
    #
    # broken in:
    #
    # shoulda-matchers-4.5.1/lib/shoulda/matchers/active_record/validate_uniqueness_of_matcher.rb
    # def next_scalar_value_for(scope, previous_value)
    #   column = column_for(scope)

    it 'does not allow to link same `topic` and `relation` twice' do
      expect do
        2.times { create_topics_relation }
      end.to change(TopicsRelation, :count).from(0).to(1)
    end
  end
end
