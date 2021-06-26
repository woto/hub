# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostsController, type: :system, responsible: :admin do
  let!(:favorites_item_kind) { :posts }
  let!(:favorite_kind) { :posts }
  let!(:ext_id) { create(:post).id }
  let(:visit_path) { posts_path(locale: :ru) }

  it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
  it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
  it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
end
