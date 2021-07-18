# frozen_string_literal: true

require 'rails_helper'

describe Tables::ArticlesController, type: :request do
  let(:path) { articles_url(host: create(:realm).domain, cols: '', order: :desc, per: 20, sort: :id) }

  it_behaves_like 'shared get_index', :guest, :ok
  it_behaves_like 'shared get_index', :user, :ok
  it_behaves_like 'shared get_index', :manager, :ok
  it_behaves_like 'shared get_index', :admin, :ok
end