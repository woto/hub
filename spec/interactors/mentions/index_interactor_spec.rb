require 'rails_helper'

describe Mentions::IndexInteractor do
  include_context 'with some entities/mentions structure'

  before do
    Mention.__elasticsearch__.refresh_index!
  end

  context 'when nothing passed (root page)' do
    subject(:interactor) { described_class.call(params: {}) }

    it 'returns mentions' do
      expect(interactor).to have_attributes(
        object: include(
          mentions: contain_exactly(
            include('_id' => mention11.id.to_s),
            include('_id' => mention19.id.to_s),
            include('_id' => mention12.id.to_s),
            include('_id' => mention15.id.to_s),
            include('_id' => mention18.id.to_s)
          )
        )
      )
    end
  end

  context 'when :entity_ids passed' do
    subject(:interactor) { described_class.call(params: { entity_ids: [entity01.id] }) }

    it 'returns mentions' do
      expect(interactor).to have_attributes(
        object: include(
          mentions: contain_exactly(
            include('_id' => mention04.id.to_s),
            include('_id' => mention06.id.to_s),
            include('_id' => mention02.id.to_s),
            include('_id' => mention01.id.to_s)
          )
        )
      )
    end
  end

  context 'when :listing_id passed' do
    subject(:interactor) { described_class.call(params: { listing_id: listings_item.favorite.id }) }

    let!(:listings_item) { create(:listings_item, ext_id: entity03.id) }

    it 'returns mentions' do
      expect(interactor).to have_attributes(
        object: include(
          mentions: contain_exactly(
            include('_id' => mention08.id.to_s),
            include('_id' => mention04.id.to_s),
            include('_id' => mention02.id.to_s),
            include('_id' => mention03.id.to_s)
          )
        )
      )
    end
  end

  context 'when :mention_id passed' do
    subject(:interactor) { described_class.call(params: { mention_id: mention17.id }) }

    it 'returns mentions' do
      expect(interactor).to have_attributes(
        object: include(
          mentions: contain_exactly(
            include('_id' => mention17.id.to_s),
            include('_id' => mention16.id.to_s),
            include('_id' => mention14.id.to_s),
            include('_id' => mention13.id.to_s),
            include('_id' => mention19.id.to_s)
          )
        )
      )
    end
  end

  describe 'pagination' do
    context 'when only one result exists' do
      subject(:interactor) { described_class.call(params: { entity_ids: [entity21.id] }) }

      it 'returns correct pagination data' do
        expect(interactor).to have_attributes(
          object: include(
            pagination: include(
              current_page: 1,
              last_page: true,
              limit_value: 5,
              offset_value: 0,
              total_count: 1,
              total_pages: 1
            )
          )
        )
      end
    end

    context 'when there are many pages and passed :page and :per' do
      subject(:interactor) { described_class.call(params: { entity_ids: [entity20.id], page: 2, per: 1 }) }

      it 'returns correct pagination data' do
        expect(interactor).to have_attributes(
          object: include(
            pagination: include(
              current_page: 2,
              last_page: false,
              limit_value: 1,
              offset_value: 1,
              total_count: 15,
              total_pages: 15
            )
          )
        )
      end
    end
  end

  describe ':mentions_search_string' do
    subject(:interactor) do
      described_class.call(params: { entity_ids: [entity20.id], mentions_search_string: 'Sunny' })
    end

    it 'returns mentions which includes :entity20 and contains the title :Sunny' do
      expect(interactor).to have_attributes(
        object: include(
          mentions: contain_exactly(
            include('_id' => mention02.id.to_s)
          )
        )
      )
    end
  end

  context 'favorite' do
    before do
      Mention.__elasticsearch__.refresh_index!
    end

    let!(:listings_item) { create(:listings_item, ext_id: entity21.id, favorite: listing) }

    context "when entity in user's favorites" do
      subject(:interactor) { described_class.call(params: { entity_ids: [entity21.id] }, current_user: user) }

      let(:listing) { create(:listing, user:) }
      let(:user) { create(:user) }

      it 'marks entities with :is_favorite' do
        expect(interactor).to have_attributes(
          object: include(
            mentions: contain_exactly(
              include(
                '_source' => include(
                  'entities' => contain_exactly(
                    include(
                      'entity_id' => entity21.id,
                      'is_favorite' => true
                    )
                  )
                )
              )
            )
          )
        )
      end
    end

    context 'when requests another user' do
      subject(:interactor) { described_class.call(params: { entity_ids: [entity21.id] }, current_user: create(:user)) }

      let(:listing) { create(:listing) }

      it 'does not mark entitiy with :is_favorite' do
        expect(interactor).to have_attributes(
          object: include(
            mentions: contain_exactly(
              include(
                '_source' => include(
                  'entities' => contain_exactly(
                    include(
                      'entity_id' => entity21.id,
                      'is_favorite' => false
                    )
                  )
                )
              )
            )
          )
        )
      end
    end

    context 'when viewing the list' do
      subject(:interactor) { described_class.call(params: { listing_id: listing.id }, current_user: create(:user)) }

      let(:listing) { create(:listing) }

      it 'marks as :is_favorite despite the :current_user' do
        expect(interactor).to have_attributes(
          object: include(
            mentions: contain_exactly(
              include(
                '_source' => include(
                  'entities' => contain_exactly(
                    include(
                      'entity_id' => entity21.id,
                      'is_favorite' => true
                    )
                  )
                )
              )
            )
          )
        )
      end
    end
  end

  describe 'response format' do
    subject(:interactor) { described_class.call(params: { entity_ids: [entity.id] }) }

    let!(:entity) { create(:entity, :with_topics, :with_lookups, :with_images) }
    let!(:mention) do
      create(:mention, :with_topics, :with_image, entities: [entity], published_at: Time.current)
    end

    before do
      Mention.__elasticsearch__.refresh_index!
    end

    it 'returns correct pagination data' do

      expect(interactor).to have_attributes(
        object: include(
          mentions: contain_exactly(
            include(
              '_id' => mention.id.to_s,
              '_score' => 2.2,
              '_source' => include(
                'id' => mention.id,
                'published_at' => be_a(String),
                'topics' => contain_exactly('id' => mention.topics.first.id, 'title' => mention.topics.first.title),
                'hostname' => mention.hostname.title,
                'url' => mention.url,
                'title' => mention.title,
                'slug' => mention.to_param,
                'created_at' => be_a(String),
                'updated_at' => be_a(String),
                'user_id' => mention.user_id,
                'image' => contain_exactly(
                  include('id')
                ),
                'entities' => contain_exactly(
                  include(
                    'title' => entity.title,
                    'entity_id' => entity.id,
                    'relevance' => mention.entities_mentions.first.relevance,
                    'sentiment' => entity.entities_mentions.first.sentiment,
                    'created_at' => be_a(String),
                    'updated_at' => be_a(String),
                    'images' => contain_exactly(
                      include(
                        'id' => entity.images.first.id
                      )
                    ),
                    'link' => Rails.application.routes.url_helpers.entity_path(entity)
                  )
                )
              )
            )
          )
        )
      )
    end
  end
end
