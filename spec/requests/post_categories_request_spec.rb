require 'rails_helper'

RSpec.describe "PostCategories", type: :request do

  xdescribe "GET /index" do
    it "returns http success" do
      get "/post_categories/index"
      expect(response).to have_http_status(:success)
    end
  end

end
