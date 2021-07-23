# frozen_string_literal: true

require 'rails_helper'

describe Table::ColumnsController, type: :request do
  subject { post table_columns_path, params: params }

  let(:params) do
    { q: 'q', per: 'per', page: 'page', sort: 'sort', order: 'order', cols: '0', model: 'accounts',
      columns_form: { displayed_columns: ['id'] }, locale: 'en' }
  end

  it 'redirects to correct path' do
    expect(subject).to redirect_to(
      accounts_path(locale: :en, cols: '0', order: 'order', page: 'page', per: 'per', q: 'q', sort: 'sort')
    )
  end
end
