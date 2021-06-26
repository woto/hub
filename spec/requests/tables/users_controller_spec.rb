# frozen_string_literal: true

require 'rails_helper'

describe Tables::UsersController, type: :request do
  let(:path) { users_path(cols: '', order: :desc, per: 20, sort: :id) }

  it_behaves_like 'shared get_index', :guest, :unauthorized
  it_behaves_like 'shared get_index', :user, :forbidden
  it_behaves_like 'shared get_index', :manager, :ok
  it_behaves_like 'shared get_index', :admin, :ok
end
