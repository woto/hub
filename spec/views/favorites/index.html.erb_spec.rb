require 'rails_helper'

RSpec.describe "favorites/index", type: :view do
  before(:each) do
    assign(:favorites, [
      Favorite.create!(
        user: nil,
        name: "Name"
      ),
      Favorite.create!(
        user: nil,
        name: "Name"
      )
    ])
  end

  it "renders a list of favorites" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "Name".to_s, count: 2
  end
end
