# frozen_string_literal: true

require 'rails_helper'

describe Ajax::PostCategories::LeavesController, responsible: :admin, type: :request do
  subject { get ajax_post_categories_leaves_path(q: 'кат', realm_id: realm.id), xhr: true }

  let(:realm) { Realm.pick(locale: :ru, kind: :post) }
  let!(:parent) { create(:post_category, title: 'Родительская категория', realm: realm) }
  let!(:child) { create(:post_category, title: 'Дочерняя категория', realm: realm, parent: parent) }

  before do
    another_realm = Realm.pick(locale: :en, kind: :post)
    create(:post_category, title: 'Другая категория', realm: another_realm)
  end

  it 'requires authentication' do
    subject
    expect(response).to have_http_status(:unauthorized)
    expect(response.body).to eq('You need to sign in or sign up before continuing.')
  end

  context 'when user is authenticated' do
    before { sign_in(Current.responsible) }

    it 'returns leaf categories' do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(['id' => child.id.to_s,
                                          'path' => 'Родительская категория',
                                          'title' => 'Дочерняя категория'])
    end
  end
end
