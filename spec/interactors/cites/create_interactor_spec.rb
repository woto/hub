# frozen_string_literal: true

require 'rails_helper'

describe Interactors::Cites::CreateInteractor do
  subject(:interactor) { described_class.call(current_user: user, params: params) }

  let(:user) { create(:user) }
  let(:fragment_url) { 'http://example.com/#:~:text=Example-,Domain,-This%20domain%20is' }

  context 'with minimal required params' do
    let(:params) { { title: '1', intro: '1' } }

    it 'does not raise exception' do
      expect { interactor }.not_to raise_error
    end

    it 'runs nested interactors', aggegate_failures: true do
      expect(Interactors::Cites::Create::ImagesInteractor).to receive(:call)
      expect(Interactors::Cites::Create::TopicsInteractor).to receive(:call)
      expect(Interactors::Cites::Create::LookupsInteractor).to receive(:call)
      expect(Elasticsearch::IndexJob).to receive(:perform_later).exactly(3).times
      expect(Mentions::IframelyJob).to receive(:perform_later)
      expect(Mentions::ScrapperJob).to receive(:perform_later)
      interactor
    end
  end

  context 'when it is new entity' do
    let(:params) { { fragment_url: fragment_url, title: 'title', intro: 'intro' } }

    it 'creates new entity with correct attributes', aggregate_failures: true do
      expect { interactor }.to change(Entity, :count)
      expect(Entity.last).to have_attributes(title: 'title', intro: 'intro', user: user)
    end
  end

  context 'when it is existed entity' do
    let(:params) { { fragment_url: fragment_url, entity_id: entity.id, title: 'title', intro: 'intro' } }
    let!(:entity) { create(:entity) }

    it 'does not create new entity' do
      expect { interactor }.not_to change(Entity, :count)
    end

    it 'updates title and intro' do
      interactor
      expect(entity.reload).to have_attributes(title: 'title', intro: 'intro')
    end

    it "does not update entity's user" do
      interactor
      expect(entity.reload).not_to have_attributes(user: user)
    end
  end

  context 'when mention with such url does not exist yet' do
    let(:fragment_url) { 'http://example.com/#:~:text=Example-,Domain,-This%20domain%20is' }
    let(:params) { { title: '1', intro: '1', fragment_url: fragment_url } }

    it 'creates new mention with correct attributes', aggregate_failures: true do
      expect { interactor }.to change(Mention, :count)
      expect(Mention.last).to have_attributes(url: 'http://example.com/', user: user)
    end
  end

  context 'when mention with such url already exists' do
    let(:fragment_url) { 'http://example.com/#:~:text=Example-,Domain,-This%20domain%20is' }
    let(:params) { { title: '1', intro: '1', fragment_url: fragment_url } }
    let!(:mention) { create(:mention, url: 'http://example.com/') }

    it 'does not create new mention', aggregate_failures: true do
      expect { interactor }.not_to change(Mention, :count)
    end

    it 'does not change user' do
      expect { interactor }.not_to(change(mention.reload, :user))
    end
  end

  context 'when mention does not have such entity and entity is new' do
    let(:fragment_url) { 'http://example.com/#:~:text=Example-,Domain,-This%20domain%20is' }
    let(:params) { { title: '1', intro: '1', fragment_url: fragment_url } }
    let!(:mention) { create(:mention, url: 'http://example.com/') }

    it 'adds entity to entities association', aggregate_failures: true do
      expect { interactor }.to change(EntitiesMention, :count)
      expect(EntitiesMention.last).to have_attributes(mention: mention)
    end

    it 'creates new entity' do
      expect { interactor }.to change(Entity, :count)
    end
  end

  context 'when mention does not have such entity but entity already exists in the database' do
    let(:fragment_url) { 'http://example.com/#:~:text=Example-,Domain,-This%20domain%20is' }
    let(:params) { { title: '1', intro: '1', fragment_url: fragment_url, entity_id: entity.id } }
    let!(:entity) { create(:entity) }
    let!(:mention) { create(:mention, url: 'http://example.com/') }

    it 'does not create new entity' do
      expect { interactor }.not_to change(Entity, :count)
    end

    it 'adds entity to entities association' do
      expect { interactor }.to change(mention.entities.reload, :count).by(1)
    end
  end

  context 'when mention already has such entity' do
    let(:fragment_url) { 'http://example.com/#:~:text=Example-,Domain,-This%20domain%20is' }
    let(:params) { { title: '1', intro: '1', fragment_url: fragment_url, entity_id: entity.id } }
    let!(:entity) { create(:entity) }
    let!(:mention) { create(:mention, url: 'http://example.com/') }

    it 'does nothing with entities association', aggregate_failures: true do
      expect { interactor }.not_to change(Entity, :count)
      expect { interactor }.not_to change(mention.entities.reload, :count)
    end
  end

  context 'with passed params' do
    let(:fragment_url) { 'http://example.com/#:~:text=Example-,Domain,-This%20domain%20is' }
    let(:params) do
      { title: 'title', intro: 'intro', fragment_url: fragment_url, entity_id: entities_mentions.entity.id,
        link_url: 'https://example.com', relevance: '1', sentiment: '1' }
    end
    let(:mention) { create(:mention, url: 'http://example.com/') }
    let!(:entities_mentions) { create(:entities_mention, mention: mention) }

    it 'creates new cite', aggregate_failures: true do
      expect { interactor }.to change(user.cites.reload, :count)
      expect(Cite.last).to(have_attributes(
                             entity: entities_mentions.entity.reload, mention: entities_mentions.mention.reload,
                             title: 'title', intro: 'intro', text_start: 'Domain', text_end: '', prefix: 'Example',
                             suffix: 'This domain is', link_url: 'https://example.com', relevance: 1, sentiment: 1))
    end
  end
end
