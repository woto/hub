# frozen_string_literal: true

require 'rails_helper'

describe Tables::NewsController, type: :request do
  let(:path) { news_index_path(cols: '', order: :desc, per: 20, sort: :id) }

  it_behaves_like 'shared get_index', :guest, :ok
  it_behaves_like 'shared get_index', :user, :ok
  it_behaves_like 'shared get_index', :manager, :ok
  it_behaves_like 'shared get_index', :admin, :ok
end
