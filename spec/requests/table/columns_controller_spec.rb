# frozen_string_literal: true

require 'rails_helper'

describe Table::ColumnsController, type: :request do
  describe '#create' do
    subject { post table_columns_path, params: params, headers: headers }

    let(:headers) { { 'ACCEPT' => 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml' } }

    context 'when params are valid' do
      let(:params) do
        {
          columns_form: {
            state: {
              q: 'q',
              per: 'per',
              page: 'page',
              sort: 'sort',
              order: 'order',
              columns: ['created_at']
            }.to_json,
            model: 'accounts',
            displayed_columns: ['', 'id']
          }
        }
      end

      it 'redirects to correct path' do
        expect(subject).to redirect_to(
          accounts_path(locale: :en,
                        q: 'q',
                        per: 'per',
                        page: 'page',
                        sort: 'sort',
                        order: 'order',
                        columns: ['id'])
        )
      end
    end

    context 'when params are not valid' do
      let(:params) { { columns_form: { model: 'feeds', state: {}.to_json, foo: :bar } } }

      it 'replaces form with turbo stream and does not create workspace' do
        sign_in(create(:user))
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to match(/turbo-stream/)
      end
    end
  end
end
