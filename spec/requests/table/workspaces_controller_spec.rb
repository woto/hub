# frozen_string_literal: true

require 'rails_helper'

describe Table::WorkspacesController do
  describe '#create' do
    subject { post(table_workspaces_path, params: params, headers: headers) }

    context 'when params is valid' do
      let(:params) do
        {
          q: 'q',
          per: 'per',
          page: 'page',
          sort: 'sort',
          order: 'order',
          cols: 'cols',
          workspace_form: { name: Faker::Lorem.word, is_default: Faker::Boolean.boolean },
          model: 'tables/feeds'
        }
      end

      let(:headers) { { 'ACCEPT' => 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml' } }

      it 'saves workspace and redirects to proper path' do
        sign_in(create(:user))
        expect do
          expect(subject).to(
            redirect_to('http://www.example.com/en/feeds?cols=cols&order=order&page=page&per=per&q=q&sort=sort')
          )
        end.to change(Workspace, :count).by(1)
      end
    end

    context 'when params is not valid' do
      let(:params) { { workspace_form: { foo: :bar }, model: 'tables/feeds' } }
      let(:headers) { { 'ACCEPT' => 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml' } }

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
