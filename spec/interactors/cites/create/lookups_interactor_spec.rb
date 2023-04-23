# frozen_string_literal: true

require 'rails_helper'

describe Cites::Create::LookupsInteractor do
  subject(:interactor) { described_class.call(cite: cite, entity: entity, user: user, params: params) }

  let(:cite) do
    mention = create(:mention, entities: [entity])
    create(:cite, entity: entity, mention: mention)
  end
  let(:entity) { create(:entity) }
  let(:user) { create(:user) }

  # NOTE: we are not interested if `destroy` value is `true` or `false`
  context 'when entity does not have passed lookup' do
    let(:params) { [{ 'id' => nil, 'destroy' => false, 'title' => 'foo' }] }

    it 'creates new lookup with correct attributes', aggregate_failures: true do
      expect { interactor }.to change(Lookup, :count).by(1)
      expect(Lookup.last).to have_attributes(user_id: user.id, title: 'foo')
    end

    it 'creates 2 lookups_relation (for cite and entity) with correct attributes', aggregate_failures: true do
      expect { interactor }.to change(LookupsRelation, :count).by(2)
      expect(LookupsRelation.find_by(relation: cite)).to have_attributes(lookup: Lookup.last, user: user)
      expect(LookupsRelation.find_by(relation: entity)).to have_attributes(lookup: Lookup.last, user: user)
    end
  end

  context 'when entity already has the passed lookup and destroy is `true`' do
    let!(:lookups_relation) { create(:lookups_relation, lookup: lookup, relation: entity) }
    let(:lookup) { create(:lookup) }
    # NOTE: we are not interested if `title` is the same or changed
    let(:params) { [{ 'id' => lookup.id, 'destroy' => true, 'title' => Faker::Lorem.word  }] }

    before do
      create(:lookups_relation, relation: create(:entity))
    end

    it 'destroys the lookups_relation', aggregate_failures: true do
      expect { interactor }.to change(LookupsRelation, :count).by(-1)
      expect { lookups_relation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'does not destroy lookup' do
      expect { interactor }.not_to change(Lookup, :count)
    end
  end

  context 'when renames lookup' do
    let(:lookup) { create(:lookup, title: 'example 1') }
    let(:params) { [{ 'id' => lookup.id, 'destroy' => false, 'title' => 'example 2' }] }
    let!(:lookups_relation) { create(:lookups_relation, lookup: lookup, relation: entity) }

    it 'destroys old lookups_relation and creates two new lookups_relations', aggregate_failures: true do
      expect { interactor }.to change(LookupsRelation, :count).by(1)
      expect { lookups_relation.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(LookupsRelation.find_by(relation: cite)).to have_attributes(lookup: Lookup.last, user: user)
      expect(LookupsRelation.find_by(relation: entity)).to have_attributes(lookup: Lookup.last, user: user)
    end

    it 'creates new lookup', aggregate_failures: true do
      expect { interactor }.to change(Lookup, :count).by(1)
      expect(Lookup.last).to have_attributes(user_id: user.id, title: 'example 2')
    end
  end

  context 'when did nothing with lookups' do
    let(:lookup) { create(:lookup) }
    let(:params) { [{ 'id' => lookup.id, 'destroy' => false, 'title' => lookup.title }] }
    let!(:lookups_relation) { create(:lookups_relation, lookup: lookup, relation: entity) }

    it 'creates lookups_relation only for cite', aggregate_failures: true do
      expect { interactor }.to change(LookupsRelation, :count)
      expect(LookupsRelation.last).to have_attributes(lookup: lookup, user: user, relation: cite)
    end
  end

  context 'when lookups is an empty array' do
    let(:params) { [] }

    it 'does not fail' do
      expect { interactor }.not_to raise_error
    end
  end
end
