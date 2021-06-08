# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system do
  let(:user) { create(:user) }

  it 'shows new post page' do
    login_as(user, scope: :user)
    visit new_post_path
    expect(response).to have_http_status(:ok)
  end
end
