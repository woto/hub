# frozen_string_literal: true

require 'rails_helper'

describe Tables::AccountsController, type: :system, responsible: :admin do
  let!(:favorites_item_kind) { :accounts }
  let!(:favorite_kind) { :accounts }
  let!(:ext_id) { create(:account).id }
  let(:visit_path) { accounts_path(locale: :ru) }

  it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
  it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
  it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
end
