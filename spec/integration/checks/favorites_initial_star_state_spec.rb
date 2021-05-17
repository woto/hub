# frozen_string_literal: true

require 'rails_helper'

describe Tables::ChecksController, type: :system, responsible: :admin do
  describe 'GET /checks' do
    before do
      allow_any_instance_of(Check).to receive(:check_amount)
    end

    it_behaves_like 'favorites_initial_starred' do
      before do
        favorite = create(:favorite, user: Current.responsible, kind: 'checks')
        create(:favorites_item, ext_id: starred_object.id, kind: 'checks', favorite: favorite)
        login_as(Current.responsible, scope: :user)
        visit checks_path
      end

      let(:starred) { "favorite-checks-#{starred_object.id}" }
      let(:starred_object) { create(:check) }
    end

    it_behaves_like 'favorites_initial_unstarred' do
      before do
        login_as(Current.responsible, scope: :user)
        visit checks_path
      end

      let(:unstarred_object) { create(:check) }
      let(:unstarred) { "favorite-checks-#{unstarred_object.id}" }
    end
  end
end
