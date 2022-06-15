# frozen_string_literal: true

require 'rails_helper'

describe Tables::TransactionsController, type: :system, responsible: :admin do
  let!(:favorites_item_kind) { :transactions }
  let!(:favorite_kind) { :transactions }
  let!(:ext_id) { create(:transaction).id }
  let(:visit_path) { transactions_path(locale: :ru) }

  it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
  it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
  it_behaves_like 'shared favorites adding favorites_item to new favorite'
  it_behaves_like 'shared favorites listing only favorites'
end
