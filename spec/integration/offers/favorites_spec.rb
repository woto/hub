# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :system do
  context "when visits favorite's offers which does not belong to current user" do
    it 'shows 404' do
      id = rand(10)
      user = create(:user)
      login_as(user, scope: :user)
      str = %(Couldn't find Favorite with 'id'=#{id} [WHERE "favorites"."kind" = $1 AND "favorites"."user_id" = $2])
      expect(Rails.logger).to receive(:error).with(str)
      expect(Yabeda.hub.http_errors).to receive(:increment).with({ http_code: 404 }, { by: 1 })
      visit offers_path(favorite_id: id, locale: :ru)
      expect(page).to have_css('h1', text: "The page you were looking for doesn't exist.")
    end
  end
end
