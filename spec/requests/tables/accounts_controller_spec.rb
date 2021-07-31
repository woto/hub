# frozen_string_literal: true

require 'rails_helper'

describe Tables::AccountsController, type: :request do
  let(:path) { accounts_path(columns: ['id'], order: :desc, per: 20, sort: :id) }

  it_behaves_like 'shared get_index', :guest, :unauthorized
  it_behaves_like 'shared get_index', :user, :ok
  it_behaves_like 'shared get_index', :manager, :ok
  it_behaves_like 'shared get_index', :admin, :ok
end
