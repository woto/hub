# frozen_string_literal: true

require 'rails_helper'

describe 'Posts shared columns', type: :system do
  let(:path) { posts_path(locale: :ru) }
  let(:user) { create(:user, role: :admin) }

  it_behaves_like 'shared columns invisible by default' do
    let(:object) { create(:post) }
    let(:select_title) { 'Intro' }
    let(:column_title) { 'Intro' }
    let(:column_value) { 'Просмотр' }
  end
end
