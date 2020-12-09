require 'rails_helper'

RSpec.describe "template3s/edit", type: :view do
  before(:each) do
    @template3 = assign(:template3, Template3.create!(
      title: "MyString"
    ))
  end

  it "renders the edit template3 form" do
    render

    assert_select "form[action=?][method=?]", template3_path(@template3), "post" do

      assert_select "input[name=?]", "template3[title]"
    end
  end
end
