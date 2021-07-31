# frozen_string_literal: true

require 'rails_helper'

describe Table::WorkspacesController do
  describe '#create' do
    subject { post(table_workspaces_path, params: params, headers: headers) }

    let(:headers) { { 'ACCEPT' => 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml' } }

    context 'when params are valid' do
      let(:params) do
        {
          workspace_form: {
            model: 'feeds',
            state: {
              q: 'q',
              per: 'per',
              page: 'page',
              sort: 'sort',
              order: 'order',
              columns: ['id']
            }.to_json,
            name: Faker::Lorem.word,
            is_default: Faker::Boolean.boolean
          }
        }
      end

      it 'saves workspace and redirects to proper path' do
        sign_in(create(:user))
        expect do
          expect(subject).to(
            redirect_to(
              feeds_url(columns: ['id'], order: 'order', page: 'page', per: 'per', q: 'q', sort: 'sort')
            )
          )
        end.to change(Workspace, :count).by(1)
      end
    end

    context 'when params are not valid' do
      let(:params) { { workspace_form: { model: 'feeds', state: {}.to_json, foo: :bar } } }

      it 'replaces form with turbo stream and does not create workspace' do
        sign_in(create(:user))
        expect do
          subject
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to match(/turbo-stream/)
        end.not_to change(Workspace, :count)
      end
    end
  end

  describe '#destroy' do
    skip
  end
end
