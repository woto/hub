# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostCategoriesController, type: :system, responsible: :admin do
  let!(:favorites_item_kind) { :post_categories }
  let!(:favorite_kind) { :post_categories }
  let!(:ext_id) { create(:post_category).id }
  let(:visit_path) { post_categories_path(locale: :ru) }

  it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
  it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
  it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
end
