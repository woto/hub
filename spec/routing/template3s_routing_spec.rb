require "rails_helper"

RSpec.describe Template3sController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/template3s").to route_to("template3s#index")
    end

    it "routes to #new" do
      expect(get: "/template3s/new").to route_to("template3s#new")
    end

    it "routes to #show" do
      expect(get: "/template3s/1").to route_to("template3s#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/template3s/1/edit").to route_to("template3s#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/template3s").to route_to("template3s#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/template3s/1").to route_to("template3s#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/template3s/1").to route_to("template3s#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/template3s/1").to route_to("template3s#destroy", id: "1")
    end
  end
end
