# frozen_string_literal: true

require 'rails_helper'

describe Interactors::Cites::Create::TopicsInteractor do
  subject(:interactor) { described_class.call(cite: cite, entity: entity, user: user, params: params) }

  let(:cite) do
    mention = create(:mention, entities: [entity])
    create(:cite, entity: entity, mention: mention)
  end
  let(:entity) { create(:entity) }
  let(:user) { create(:user) }

  context 'when entity does not have passed topic and topic is not existed in database' do
    let(:params) { [{ 'id' => nil, 'destroy' => false, 'title' => 'foo' }] }

    it 'creates new topic with correct attributes', aggregate_failures: true do
      expect { interactor }.to change(Topic, :count).by(1)
      expect(Topic.last).to have_attributes(user_id: user.id, title: 'foo')
    end

    it 'creates 2 topics_relation (for cite and entity) with correct attributes', aggregate_failures: true do
      expect { interactor }.to change(TopicsRelation, :count).by(2)
      expect(TopicsRelation.find_by(relation: cite)).to have_attributes(topic: Topic.last, user: user)
      expect(TopicsRelation.find_by(relation: entity)).to have_attributes(topic: Topic.last, user: user)
    end

    it 'indexes newly created topic' do
      allow(Elasticsearch::IndexJob).to receive(:perform_later)
      interactor
      expect(Elasticsearch::IndexJob).to have_received(:perform_later).with(Topic.last)
    end
  end

  context 'when entity does not have passed topic but topic is existed in database' do
    let!(:topic) { create(:topic) }
    let(:params) { [{ 'id' => nil, 'destroy' => false, 'title' => topic.title }] }
    let(:topics_relation) { create(:topics_relation, topic: topic, relation: entity) }

    it 'does not create new topic' do
      expect { interactor }.not_to change(Topic, :count)
    end

    it 'creates 2 topics_relation (for cite and entity) with correct attributes', aggregate_failures: true do
      expect { interactor }.to change(TopicsRelation, :count).by(2)
      expect(TopicsRelation.find_by(relation: cite)).to have_attributes(topic: topic, user: user)
      expect(TopicsRelation.find_by(relation: entity)).to have_attributes(topic: topic, user: user)
    end
  end

  context 'when entity already has the passed topic and destroy is `true`' do
    let!(:topics_relation) { create(:topics_relation, topic: topic, relation: entity) }
    let(:topic) { create(:topic) }
    # NOTE: we are not interested if `title` is the same or changed
    let(:params) { [{ 'id' => topic.id, 'destroy' => true, 'title' => Faker::Lorem.word }] }

    before do
      create(:topics_relation, relation: create(:entity))
    end

    it 'destroys the topics_relation', aggregate_failures: true do
      expect { interactor }.to change(TopicsRelation, :count).by(-1)
      expect { topics_relation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'does not destroy topic' do
      expect { interactor }.not_to change(Topic, :count)
    end

    it 'reindexes count of topic' do
      allow(Elasticsearch::IndexJob).to receive(:perform_later)
      interactor
      expect(Elasticsearch::IndexJob).to have_received(:perform_later).with(topic)
    end
  end

  context 'when assigns already assigned to entity topic' do
    let(:topic) { create(:topic) }
    let(:params) { [{ 'id' => topic.id, 'destroy' => false, 'title' => topic.title }] }
    let!(:topics_relation) { create(:topics_relation, topic: topic, relation: entity) }

    it 'does not create new topic' do
      expect { interactor }.not_to change(Topic, :count)
    end

    it 'creates topics_relation only for cite', aggregate_failures: true do
      expect { interactor }.to change(TopicsRelation, :count).by(1)
      expect(TopicsRelation.last).to have_attributes(topic: topic, user: user)
    end

    it 'reindexes count of topic' do
      allow(Elasticsearch::IndexJob).to receive(:perform_later)
      interactor
      expect(Elasticsearch::IndexJob).to have_received(:perform_later).with(topic)
    end
  end

  context 'when assigns not yet assigned topic, but already existed in the database' do
    let(:topic) { create(:topic) }
    let(:params) { [{ 'id' => topic.id, 'destroy' => false, 'title' => topic.title }] }

    it 'creates 2 topics_relation (for cite and entity) with correct attributes', aggregate_failures: true do
      expect { interactor }.to change(TopicsRelation, :count).by(2)
      expect(TopicsRelation.find_by(relation: cite)).to have_attributes(topic: topic, user: user)
      expect(TopicsRelation.find_by(relation: entity)).to have_attributes(topic: topic, user: user)
    end

    it 'reindexes count of topic' do
      allow(Elasticsearch::IndexJob).to receive(:perform_later)
      interactor
      expect(Elasticsearch::IndexJob).to have_received(:perform_later).with(topic)
    end
  end

  context 'when topics is an empty array' do
    let(:params) { [] }

    it 'does not fail' do
      expect { interactor }.not_to raise_error
    end
  end
end
