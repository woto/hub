# frozen_string_literal: true

require 'rails_helper'

describe Interactors::Cites::Create::AggregateInteractor do
  subject(:interactor) { described_class.call(entity: entity, mention: mention) }

  let(:entity) { create(:entity) }
  let(:mention) { create(:mention) }

  context 'when entities_mention does not exist yet' do
    before do
      create(:cite, entity: entity, mention: mention)
    end

    it 'creates new entities_mention' do
      expect { interactor }.to change(EntitiesMention, :count).by(1)
    end
  end

  context 'when entities_mention already exists' do
    before do
      create(:cite, entity: entity, mention: mention)
      create(:entities_mention, entity: entity, mention: mention)
    end

    it 'does not create new entities_mention' do
      expect { interactor }.not_to change(EntitiesMention, :count)
    end
  end

  describe 'aggregated fields' do
    let!(:entities_mention) { create(:entities_mention, entity: entity, mention: mention) }

    around do |example|
      freeze_time do
        example.run
      end
    end

    before do
      create_list(:cite, 2, entity: entity, mention: mention, relevance: 0, sentiment: 0, mention_date: Time.current)
      create(:cite, entity: entity, mention: mention, relevance: 1, sentiment: 1, mention_date: 1.day.ago)
    end

    it 'updates relevance to the `mode` value of the three records (because mode value used)' do
      expect { interactor }.to change { entities_mention.reload.relevance }.from(nil).to(0)
    end

    it 'updates mention_date to the `mode` value of the three records (because mode value used)' do
      expect { interactor }.to change { entities_mention.reload.mention_date }.from(nil).to(Time.current)
    end

    it 'updates sentiment to the `average` value of the three records (because average value used)' do
      expect { interactor }.to change { entities_mention.reload.sentiment }.from(nil).to(be_within(0.01).of(0.33))
    end
  end
end
