# frozen_string_literal: true

require 'rails_helper'

describe FavoritesStore do
  subject(:favorites_store) { described_class.new(user:, listing:) }

  let(:user) { nil }
  let(:listing) { nil }

  describe 'different `kinds`' do
    before do
      subject.append(favorites_item.ext_id, favorites_item.kind)
    end

    let(:favorites_item) { create(:favorites_item, ext_id: 'a1', kind: :users, user: create(:user)) }

    context 'when `favorites_items.kind` is an `:users` and `subject.find(..., :users)`' do
      it 'finds' do
        expect(subject.find(favorites_item.ext_id, :users)).to be_truthy
      end
    end

    context 'when `favorites_items.kind` is an `:users` and `subject.find(..., :posts)`' do
      it 'does not find' do
        expect(subject.find(favorites_item.ext_id, :posts)).to be_falsey
      end
    end
  end

  describe 'different `favorites_items.user`' do
    let(:user) { create(:user) }

    before do
      subject.append(favorites_item.ext_id, favorites_item.kind)
    end

    context 'when favorites_item belongs to the user' do
      let(:favorites_item) { create(:favorites_item, ext_id: 'a1', kind: :feeds, user:) }

      it 'finds' do
        expect(subject.find(favorites_item.ext_id, :feeds)).to be_truthy
      end
    end

    context 'when favorites_item does not belong to the user' do
      let(:favorites_item) { create(:favorites_item, ext_id: 'a1', kind: :feeds, user: create(:user)) }

      it 'does not find' do
        expect(subject.find(favorites_item.ext_id, :feeds)).to be_falsey
      end
    end
  end

  it 'issues at most one SQL select query' do
    favorites_item1 = create(:favorites_item)
    favorites_item2 = create(:favorites_item)
    subject.append(favorites_item1.ext_id, favorites_item1.kind)
    subject.append(favorites_item2.ext_id, favorites_item2.kind)

    expect do
      subject.find(favorites_item1.ext_id, favorites_item1.kind)
      subject.find(favorites_item2.ext_id, favorites_item2.kind)
    end.not_to exceed_query_limit(1)
  end

  describe 'different `listing`' do
    let(:listing) { create(:favorite) }

    before do
      subject.append(favorites_item.ext_id, favorites_item.kind)
    end

    context 'when favorites_item belongs to the listing' do
      let(:favorites_item) { create(:favorites_item, ext_id: 'a1', kind: listing.kind, favorite: listing) }

      it 'finds' do
        expect(subject.find(favorites_item.ext_id, listing.kind)).to be_truthy
      end
    end

    context 'when favorites_item does not belong to the user' do
      let(:lst) { create(:favorite, kind: listing.kind) }
      let(:favorites_item) { create(:favorites_item, ext_id: 'a1', kind: lst.kind, favorite: lst) }

      it 'does not find' do
        expect(subject.find(favorites_item.ext_id, listing.kind)).to be_falsey
      end
    end
  end
end
