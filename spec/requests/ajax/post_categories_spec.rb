# frozen_string_literal: true

require 'rails_helper'

describe Ajax::PostCategoriesController, type: :request do
  subject { get ajax_categories_path(q: 'кат', realm_id: realm.id), xhr: true }

  # let(:headers) { { 'Accept' => 'application/json' } }
  let(:user) { create(:user) }

  let(:realm) { create(:realm) }
  let!(:parent) { create(:post_category, title: 'Родительская категория', realm: realm) }
  let!(:child) { create(:post_category, title: 'Дочерняя категория', realm: realm, parent: parent) }

  it 'requires authentication' do
    subject
    expect(response).to have_http_status(:unauthorized)
    expect(response.body).to eq('You need to sign in or sign up before continuing.')
  end

  context 'when user is authenticated' do
    before { sign_in(user) }

    it 'returns leaf categories' do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(['id' => child.id.to_s,
                                          'path' => 'Родительская категория',
                                          'title' => 'Дочерняя категория'])
    end
  end
end
