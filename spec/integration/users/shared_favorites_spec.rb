# frozen_string_literal: true

require 'rails_helper'

describe Tables::UsersController, type: :system, responsible: :admin do
  let!(:favorites_item_kind) { :users }
  let!(:favorite_kind) { :users }
  let!(:ext_id) { create(:user).id }
  let(:visit_path) { users_path(locale: :ru) }

  it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
  it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
  it_behaves_like 'shared favorites adding favorites_item to new favorite'
  it_behaves_like 'shared favorites listing only favorites'
end
