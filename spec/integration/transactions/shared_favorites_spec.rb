# frozen_string_literal: true

require 'rails_helper'

describe Tables::TransactionsController, type: :system, responsible: :admin do
  let!(:favorites_item_kind) { :transactions }
  let!(:favorite_kind) { :transactions }
  let!(:ext_id) { create(:transaction).id }
  let(:visit_path) { transactions_path }

  it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
  it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
  it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
end
