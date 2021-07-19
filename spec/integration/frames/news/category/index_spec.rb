# frozen_string_literal: true

require 'rails_helper'

describe 'Frames::Articles::MonthController#index', type: :system, responsible: :admin do
  let(:realm) { create(:realm, locale: :ru, kind: :news) }
  let(:parent_category) { create(:post_category, realm: realm) }
  let(:child_category) { create(:post_category, realm: realm, parent: parent_category) }
  let!(:article) do
    create(:post, realm_kind: :news, post_category: child_category, status: :accrued_post)
  end

  context 'when parent category passed in the params' do
    before do
      switch_realm(realm) do
        visit frames_articles_category_path(parent_category, order: :order, per: :per, sort: :sort)
      end
    end

    it 'shows link to the the root' do
      expect(page).to have_link('Главная', href: articles_path(order: :order, per: :per, sort: :sort))
    end

    it 'shows link to the child category' do
      expect(page).to have_link(child_category.to_label,
                                href: articles_by_category_path(
                                  category_id: child_category, order: :order, per: :per, sort: :sort
                                ))
    end
  end

  context 'when child category passed in the params' do
    before do
      switch_realm(realm) do
        visit frames_articles_category_path(child_category, order: :order, per: :per, sort: :sort)
      end
    end

    it 'shows link to the the root' do
      expect(page).to have_link('Главная', href: articles_path(order: :order, per: :per, sort: :sort))
    end

    it 'shows link to the parent category' do
      expect(page).to have_link(parent_category.to_label,
                                href: articles_by_category_path(
                                  category_id: parent_category, order: :order, per: :per, sort: :sort
                                ))
    end
  end

  context 'when there is no category in params' do
    it 'shows root categories' do
      switch_realm(realm) do
        visit frames_articles_category_path(nil, order: :order, per: :per, sort: :sort)
      end

      expect(page).to have_link(parent_category.to_label,
                                href: articles_by_category_path(
                                  category_id: parent_category, order: :order, per: :per, sort: :sort
                                ))
    end
  end
end
