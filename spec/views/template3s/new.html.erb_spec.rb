require 'rails_helper'

RSpec.describe "template3s/new", type: :view do
  before(:each) do
    assign(:template3, Template3.new(
      title: "MyString"
    ))
  end

  it "renders new template3 form" do
    render

    assert_select "form[action=?][method=?]", template3s_path, "post" do

      assert_select "input[name=?]", "template3[title]"
    end
  end
end
