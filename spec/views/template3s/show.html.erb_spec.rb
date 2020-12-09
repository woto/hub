require 'rails_helper'

RSpec.describe "template3s/show", type: :view do
  before(:each) do
    @template3 = assign(:template3, Template3.create!(
      title: "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
  end
end
