# frozen_string_literal: true

require 'rails_helper'

describe Ajax::PostCategories::EmptiesController, responsible: :admin, type: :request do
  subject { get ajax_post_categories_empties_path(q: 'кат', realm_id: realm.id), xhr: true }

  let(:realm) { Realm.pick(locale: :ru, kind: :post) }
  let!(:parent) { create(:post_category, title: 'Родительская категория', realm: realm) }
  let!(:child) { create(:post_category, title: 'Дочерняя категория', realm: realm, parent: parent) }

  before do
    another_realm = Realm.pick(locale: :en, kind: :post)
    create(:post_category, title: 'Другая категория', realm: another_realm)

    post_category_with_post = create(:post_category, title: 'Другая категория', realm: realm)
    create(:post, post_category: post_category_with_post)
  end

  it 'requires authentication' do
    subject
    expect(response).to have_http_status(:unauthorized)
    expect(response.body).to eq('You need to sign in or sign up before continuing.')
  end

  context 'when user is authenticated' do
    before { sign_in(Current.responsible) }

    it 'returns only categories without posts categories' do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to(
        match_array(
          [
            { 'id' => child.id.to_s, 'path' => 'Родительская категория', 'title' => 'Дочерняя категория' },
            { 'id' => parent.id.to_s, 'path' => '', 'title' => 'Родительская категория' }
          ]
        )
      )
    end
  end
end
