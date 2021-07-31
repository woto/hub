# frozen_string_literal: true

require 'rails_helper'

describe 'Checks shared columns', type: :system do
  before do
    allow_any_instance_of(Check).to receive(:check_amount)
  end

  # NOTE: there are no such columns for now
  # it_behaves_like 'shared columns invisible by default' do
  #   skip
  # end

  it_behaves_like 'shared columns visible only to admin' do
    let(:path) { checks_path({ columns: %w[id user_id], order: :desc, per: 20, sort: :id, locale: :ru }) }
    let(:object) { create(:check, user: user) }
    let(:column_id) { 'user_id' }
    let(:select_title) { 'User' }
    let(:column_title) { 'User' }
    let(:column_value) { user.id }
  end
end
