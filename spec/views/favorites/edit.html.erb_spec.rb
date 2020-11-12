require 'rails_helper'

RSpec.describe "favorites/edit", type: :view do
  before(:each) do
    @favorite = assign(:favorite, Favorite.create!(
      user: nil,
      name: "MyString"
    ))
  end

  it "renders the edit favorite form" do
    render

    assert_select "form[action=?][method=?]", favorite_path(@favorite), "post" do

      assert_select "input[name=?]", "favorite[user_id]"

      assert_select "input[name=?]", "favorite[name]"
    end
  end
end
