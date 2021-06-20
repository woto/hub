# frozen_string_literal: true

require 'rails_helper'

describe Tables::ChecksController, type: :system, responsible: :admin do
  before do
    allow_any_instance_of(Check).to receive(:check_amount)
  end

  let!(:favorites_item_kind) { :checks }
  let!(:favorite_kind) { :checks }
  let!(:ext_id) { create(:check).id }
  let(:visit_path) { checks_path }

  it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
  it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
  it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
end