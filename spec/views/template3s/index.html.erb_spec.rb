require 'rails_helper'

RSpec.describe "template3s/index", type: :view do
  before(:each) do
    assign(:template3s, [
      Template3.create!(
        title: "Title"
      ),
      Template3.create!(
        title: "Title"
      )
    ])
  end

  it "renders a list of template3s" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
  end
end
