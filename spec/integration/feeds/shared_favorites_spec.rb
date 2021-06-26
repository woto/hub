# frozen_string_literal: true

require 'rails_helper'

describe Tables::FeedsController, type: :system, responsible: :admin do
  let!(:favorites_item_kind) { :feeds }
  let!(:favorite_kind) { :feeds }
  let!(:ext_id) { create(:feed).id }
  let(:visit_path) { feeds_path(locale: :ru) }

  it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
  it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
  it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
end
