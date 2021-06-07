# frozen_string_literal: true

require 'rails_helper'

describe Ajax::PostTagsController, type: :request, responsible: :user do
  subject { get ajax_tags_path(q: 'тег', realm_id: realm.id), xhr: true }

  let(:user) { create(:user) }
  let(:realm) { create(:realm) }

  before do
    create(:post, tags: ['', 'первый тег', 'some tag'], realm: realm)
    create(:post, tags: ['', 'тег в этом же realm'], realm: realm)
    create(:post, tags: ['', 'mismatch'], realm: realm)
    create(:post, tags: ['', 'тег в другом realm'])
  end

  it 'requires authentication' do
    subject
    expect(response).to have_http_status(:unauthorized)
    expect(response.body).to eq('You need to sign in or sign up before continuing.')
  end

  context 'when user is authenticated' do
    before { sign_in(user) }

    # TODO: The code of Ajax::PostTagsController should be written better.
    # We do not want to see here non matching tags - "some tag".
    # For now it's acceptable because selectize itself filter out bad tags.

    it 'returns tags' do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to contain_exactly(
        { 'title' => '' },
        { 'title' => 'some tag' },
        { 'title' => 'первый тег' },
        { 'title' => 'тег в этом же realm' }
      )
    end
  end
end
